class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.text :body
      t.float :latitude
      t.float :longitude
      t.string :address
      t.string :status

      t.timestamps
    end
  end
end
