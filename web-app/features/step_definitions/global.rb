When(/^залогинен модератор с email "([^"]*)" и паролем "([^"]*)"$/) do |email, password|
  visit('/users/sign_in')
  within('#new_user') do
    fill_in('Почта', with: email)
    fill_in('Пароль', with: password)
    click_button('Войти')
  end
end

When(/^он находится на главной странице$/) do
  visit(root_path)
end
