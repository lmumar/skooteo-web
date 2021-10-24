# frozen_string_literal: true

module Admin
  class UsersController < BaseController
    before_action :set_users, only: %w(index)
    before_action :set_user, only: %w(edit update)

    def new
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.update("modal-container", partial: "edit")
        }
      end
    end

    def create
      @user = User.create!(user_params)
    end

    def update
      @user.update! user_params
    end

    private
      def set_users
        @users = User.search(
          page: params[:page] || 1,
          per_page: params[:per_page],
          filters: { query: params[:q] }
        )
      end

      def set_user
        @user = User.find params[:id]
      end

      def user_params
        params.require(:user).
          permit(
            :email,
            :password,
            :company_id,
            person_attributes: [:last_name, :first_name, :id],
            user_role_attributes: [:id, :grantor_id, :role_id]
          )
      end
  end
end
