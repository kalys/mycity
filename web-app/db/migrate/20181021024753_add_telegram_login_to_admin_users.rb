class AddTelegramLoginToAdminUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :admin_users, :telegram_login, :string
  end
end
