class CreateTimeCards < ActiveRecord::Migration[5.0]
  def change
    create_table :time_cards do |t|
      t.string    :username
      t.datetime  :occurrence
      t.integer   :total_time

      t.timestamps
    end
  end
end
