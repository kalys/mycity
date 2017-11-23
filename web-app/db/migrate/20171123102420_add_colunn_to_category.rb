class AddColunnToCategory < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :archive, :boolean, default: false
  end
end
