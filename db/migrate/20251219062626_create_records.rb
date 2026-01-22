class CreateRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :records do |t|
      t.integer :user_id
      t.datetime :start_time
      t.datetime :end_time
      t.integer :library_id

      t.timestamps
    end
  end
end
