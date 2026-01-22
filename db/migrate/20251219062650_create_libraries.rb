class CreateLibraries < ActiveRecord::Migration[8.1]
  def change
    create_table :libraries do |t|
      t.integer :user_id
      t.string :api_str

      t.timestamps
    end
  end
end
