class Timecard < ApplicationRecord
  has_many :time_entries

  def update_total_time
    if time_entries.count >= 2
      self.update_attributes(:total_time => get_total_time)
    elsif !self.total_time.nil?
      self.update_attributes(:total_time => nil)
    end
  end

  def get_total_time
    max_date = get_max_date(time_entries)
    min_date = get_min_date(time_entries)
    (max_date - min_date) * 1.days
  end

  # TODO: Put the column accessor [:time] into something configurable
  def get_max_date(hash)
    hash.max_by{|h| h[:time]}[:time]
  end

  def get_min_date(hash)
    hash.min_by{|h| h[:time]}[:time]
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
