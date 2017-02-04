module Api::V1
  class TimecardsController < ApplicationController
    skip_before_filter :verify_authenticity_token

    def index
      render json: Timecard.all
    end

    def show
      timecard = timecard_from_id

      if timecard
        render json: timecard
      else
        head :not_found
      end
    end

    def create
      #TODO: validate first with .new and .save
      if timecard = Timecard.create(timecard_params)
        render json: timecard
      else
        head :unprocessable_entity
      end
    end

    def update
      timecard = timecard_from_id

      if timecard && timecard.update_attributes(timecard_params)
        # Could return an empty 200 instead
        render json: timecard
      else
        if timecard && timecard.errors
          render json: timecard.errors, status: :unprocessable_entity
        else
          head :unprocessable_entity
        end
      end
    end

    def destroy
      timecard = timecard_from_id
      if timecard && timecard.delete
        head :ok
      else
        head :unprocessable_entity
      end
    end

    private

    def timecard_from_id
      # May also use .find_by_id, but this is clearer
      Timecard.find(params[:id]) if Timecard.exists? id: params[:id]
    end

    def timecard_params
      params.require(:timecard).permit(
        :username,
        :occurrence
      )
    end
  end
end
