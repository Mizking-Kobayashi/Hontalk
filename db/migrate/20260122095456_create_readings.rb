class CreateReadings < ActiveRecord::Migration[8.1]
  def change
    create_table :readings do |t|
      # referencesで指定するとユーザーが消えた時に対応するデータが消える
      t.references :user, null: false, foreign_key: true
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end
end
