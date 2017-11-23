class AddColunnToCategory < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :archived, :boolean, default: false
  end
end
