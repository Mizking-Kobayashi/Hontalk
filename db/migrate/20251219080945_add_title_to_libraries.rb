class AddTitleToLibraries < ActiveRecord::Migration[8.1]
  def change
    add_column :libraries, :title, :string
  end
end
