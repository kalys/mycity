Fabricator(:admin_user) do
  email { Faker::Internet.email }
  telegram_login { rand(10000..99999) }
  password { Faker::Internet.password }
end
