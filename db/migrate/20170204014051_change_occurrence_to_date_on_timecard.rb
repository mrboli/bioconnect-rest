class ChangeOccurrenceToDateOnTimecard < ActiveRecord::Migration[5.0]
  def change
    change_column :timecards, :occurrence, :date
  end
end
