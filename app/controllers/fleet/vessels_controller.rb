# frozen_string_literal: true

module Fleet
  class VesselsController < BaseController
    before_action :set_vessels, only: %w(index)
    before_action :set_vessel, only: %w(edit update destroy)

    def index
    end

    def new
      @vessel = Current.company.vehicles.new(vehicleable: Vessel.new)
    end

    def edit
      respond_to do |format|
        format.js
        format.html {
          render partial: 'form', layout: false
        }
      end
    end

    def create
      @vessel = Current.company.vehicles.create(
        name: vessel_params[:name],
        image: vessel_params[:image],
        capacity: vessel_params[:capacity],
        vehicleable: Vessel.new(kind: vessel_params[:kind])
      )
    end

    def update
      @vessel.transaction do
        @vessel.update! vessel_params.except(:kind)
        @vessel.vehicleable.update! vessel_params.slice(:kind)
      end
    end

    def destroy
      @vessel.destroy
      respond_to do |format|
        format.js
      end
    end

    private
      def set_vessels
        query = params.slice(:route_id, :status, :capacity).merge(name: params[:vehicle_name])
        @vessels ||= Vessel.results(filters: query.merge(company: Current.company))
      end

      def set_vessel
        @vessel = Current.company.vessels.find params[:id]
      end

      def vessel_params
        params.require(:vessel).permit(:kind, :capacity, :name, :image, :credits_per_spot, :status)
      end
  end
end
