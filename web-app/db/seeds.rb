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
	mess = Message.new
	mess.body = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis molestie aliquam malesuada. Aliquam ut malesuada sem. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris id consectetur ligula. Quisque egestas ultrices turpis, eu imperdiet purus porta eu. Praesent vel urna at lorem aliquam tristique. Vivamus eu turpis ut diam pellentesqu"
	mess.latitude = 123.1
	mess.longitude = 123.1
	mess.address = "some address"
	mess.category_id = default_category.id
	mess.save
	image = Image.new
	File.open(Rails.root.join("app", "assets", "images", "1.png")) do |f|
		image.image = f
	end
	image.message_id = mess.id
	image.save
end