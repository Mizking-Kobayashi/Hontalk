class CreateComments < ActiveRecord::Migration[8.1]
  def change
    create_table :comments do |t|
      # t.references を使うと自動的に user_id カラムとインデックスが作られます
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      
      # 本文。長いコメントも想定して string より text がおすすめ
      t.text :body, null: false

      t.timestamps
    end
  end
end