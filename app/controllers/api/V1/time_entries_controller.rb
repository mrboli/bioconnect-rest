class Api::V1::TimeEntriesController < ApplicationController
  after_action :update_timecard_total_time, only: [:create, :update, :destroy]
  
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
    if @time_entry = Timecard.create_time_entry(time_entry_params)
      render json: @time_entry
    else
      head :unprocessable_entity
    end
  end

  def update
    @time_entry = TimeEntry.find_by_id(params[:id])

    if @time_entry && @time_entry.update_attributes(time_entry_params)
      render json: @time_entry
    else
      if @time_entry && @time_entry.errors
        render json: @time_entry.errors, status: :unprocessable_entity
      else
        head :unprocessable_entity
      end
    end
  end

  def destroy
    @time_entry = time_entry_from_id

    if @time_entry && @time_entry.delete
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def update_timecard_total_time
    # TODO: Not a possible case right now, but a time entry without a timecard id will cause an exception
    @time_entry.timecard.update_total_time
  end

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
