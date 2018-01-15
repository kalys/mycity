When(/^я перейду на страницу входа и в поле "([^"]*)" введу "([^"]*)", а в поле "([^"]*)" введу "([^"]*)"$/) do |email_field, email, password_field, password |
  visit('users/sign_in')
  within('#new_user') do
    fill_in(email_field, with: email)
    fill_in(password_field, with: password)
    click_button("Войти")
  end
end

When(/^я попаду на страницу сообщений, а в углу появится кнопка "([^"]*)"$/) do |button_text|
  assert page.has_content?(button_text)
end

When(/^пользователь, будучи залогинен под "([^"]*)" и "([^"]*)", нажмёт на кнопку "([^"]*)"$/) do |email, password, button|
  visit('users/sign_in')
  within('#new_user') do
    fill_in('Почта', with: email)
    fill_in('Пароль', with: password)
    click_button("Войти")
  end
  visit(messages_path)
  click_link(button)
end

When(/^он попадёт на страницу входа с заглавием "([^"]*)"$/) do |page_header|
  assert page.has_content?(page_header)
end


When(/^пользователь при входе введёт заведомо неверные данные, например, "([^"]*)" и "([^"]*)"$/) do |email, password|
  visit('users/sign_in')
  within('#new_user') do
    fill_in("Почта", with: email)
    fill_in("Пароль", with: password)
    click_button('Войти')
  end
end

When(/^на мониторе появляется надпись "([^"]*)"$/) do |page_header|
  assert page.has_content?(page_header)
end
