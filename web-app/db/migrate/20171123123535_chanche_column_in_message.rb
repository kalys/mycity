class ChancheColumnInMessage < ActiveRecord::Migration[5.1]
  def change
  	change_column :messages, :status, :integer
  end
end
