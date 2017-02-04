class Timecard < ApplicationRecord
  has_many :time_entries

  def update_total_time
    
  end

  class << self
    def create_time_entry(time_entry_params)
      timecard = Timecard.find_by_id(time_entry_params[:timecard_id])
      if timecard
        # Can't call create directly because there is no return on fail
        time_entry = timecard.time_entries.build(time_entry_params)

        if time_entry.save
          update_total_time if timecard.time_entries.count >= 2

          return time_entry
          # TODO: return model with errors
        end
      else
        # TODO: Notify the API consumer that the timecard doesn't exist
      end
    end
  end
end
