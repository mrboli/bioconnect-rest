class ChangeTimeFromIntToBigIntOnTimecard < ActiveRecord::Migration[5.0]
  def change
    change_column :timecards, :total_time, :bigint
  end
end
