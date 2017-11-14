# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin_role = ::Role.where(name: :admin).first_or_create!(
        name:        :admin,
        title:       "Role for admin",
        description: "This user can do anything"
      )
admin_role.create_rule(:system, :administrator)
admin_role.rule_on(:system, :administrator)
admin_role


moderator_role = Role.create!(name: 'moderator', 
															title: 'Role for moderator', 
															description: 'Модератор может обрабатывать сообщения от пользователей')

admin = User.create!(name: 'Administrator', email: 'admin@admin.ru', password: 'qweqweqwe', role_id: 1)
user = User.create!(name: 'User', email: 'user@user.ru', password: 'qweqweqwe', role_id: moderator_role.id)