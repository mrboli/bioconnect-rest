class CreateTimeEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :time_entries do |t|
      t.datetime    :time

      t.references :timecard, index: true, foreign_key: true

      t.timestamps
    end
  end
end
