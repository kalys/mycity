Fabricator(:admin_user) do
  email { Faker::Internet.email }
  telegram_login { Faker::Internet.username }
  password { Faker::Internet.password }
end
