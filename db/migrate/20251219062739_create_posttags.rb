class CreatePosttags < ActiveRecord::Migration[8.1]
  def change
    create_table :posttags do |t|
      t.integer :post_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
