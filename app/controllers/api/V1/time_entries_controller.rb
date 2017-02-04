module Api::V1
  class TimeEntriesController < ApplicationController
    skip_before_filter :verify_authenticity_token
    
    def index
      render json: TimeEntry.all
    end

    def show
      time_entry = time_entry_from_id

      if time_entry
        render json: time_entry
      else
        head :not_found
      end
    end

    def create
      if time_entry = Timecard.create_time_entry(time_entry_params)
        render json: time_entry
      else
        head :unprocessable_entity
      end
    end

    def update
      time_entry = TimeEntry.find_by_id(params[:id])

      if time_entry && time_entry.update_attributes(time_entry_params)
        render json: time_entry
      else
        if time_entry && time_entry.errors
          render json: time_entry.errors, status: :unprocessable_entity
        else
          head :unprocessable_entity
        end
      end
    end

    def destroy
      time_entry = time_entry_from_id
      if time_entry && time_entry.delete
        head :ok
      else
        head :unprocessable_entity
      end
    end

    private

    def time_entry_from_id
      TimeEntry.find(params[:id]) if TimeEntry.exists? id: params[:id]
    end

    def time_entry_params
      params.require(:time_entry).permit(
        :time,
        :timecard_id
      )
    end
  end
end
