# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin_role = ::Role.where(name: :admin).first_or_create!(
        name:        :admin,
        title:       "Администраторы",
        description: "Пользователи этой группы имеют глобальный доступ"
      )
admin_role.create_rule(:system, :administrator)
admin_role.rule_on(:system, :administrator)
admin_role


moderator_role = Role.create!(name: 'moderator', 
												title: 'Модераторы', 
												description: 'Пользователи этой группы могут обрабатывать сообщения от пользователей',
												the_role: "{\"messages\":{\"index\":true,\"edit\":true,\"show\":true,\"update\":true}}")


admin = User.create!(name: 'Administrator', email: 'admin@admin.ru', password: 'qweqweqwe', role_id: 1)
user = User.create!(name: 'User', email: 'user@user.ru', password: 'qweqweqwe', role_id: moderator_role.id)

default_category = Category.create(title: "default")

30.times do
	Message.create(body: "Some text", latitude: 123.0, longitude: 123.0, address: "some address", category_id: default_category.id)
end