# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Category.create!(title: 'default')
Category.create!(title: 'Тестовая категория')

User.create!(name: 'Administrator', email: 'admin@admin.ru', password: 'qweqweqwe')
User.create!(name: 'Moderator', email: 'moder@moder.ru', password: 'qweqweqwe')
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?
