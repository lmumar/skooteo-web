# frozen_string_literal: true

module Playlists::Admin
  extend ActiveSupport::Concern

  included do
    before_action :set_playlists, only: %w(index)
    before_action :set_playlist, only: %w(edit update destroy archive set_default)
  end

  def new
    @playlist = Current.company.playlists.build
  end

  def edit
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update('modal-container', partial: 'edit') }
      format.html         { redirect_to polymorphic_path([namespace, Playlist], playlist_type: playlist_type) }
    end
  end

  def create
    @playlist = Current.company.playlists.build playlist_params
    @playlist.active!
  end

  def update
    @playlist.update(playlist_params)
  end

  def destroy
    authorize @playlist.becomes(Playlist)
    @playlist.destroy
    @playlist.broadcast_remove_to 'fleet:playlist'
    respond_to do |format|
      format.any do
        head :ok
      end
    end
  end

  def set_default
    previous_default_playlist = @playlist.set_default!
    playlist_partial_path = [self.class.controller_path, 'playlist'].join('/')
    @playlist.broadcast_replace_to 'fleet:playlist', partial: playlist_partial_path

    if previous_default_playlist
      previous_default_playlist.broadcast_replace_to 'fleet:playlist', partial: playlist_partial_path
    end

    respond_to do |format|
      format.any do
        head :ok
      end
    end
  end

  protected
    def namespace
      raise NotImplementedError
    end

    def playlist_type
      params[:playlist_type] || 'OnboardingPlaylist'
    end

  private
    def set_playlists
      @playlists = Current.company.playlists.
        where(type: playlist_type).
        where.not(status: Playlist.statuses[:archived]).
        order(:created_at)
    end

    def set_playlist
      @playlist = Current.company.playlists.find(params[:id])
    end

    def playlist_params
      params.require(:playlist).permit(:name, :type)
    end
end
