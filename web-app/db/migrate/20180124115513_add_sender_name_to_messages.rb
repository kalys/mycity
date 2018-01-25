class AddSenderNameToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :sender_name, :string
  end
end
