When(/администратор нажмёт кнопку "([^"]*)"/) do |button|
  visit(root_path)
  click_button(button)
end

When(/^он окажется на странице с формой отправки приглашения, которая озаглавлена "([^"]*)"$/) do |page_header|
  assert page.has_content?(page_header)
end

When(/^администратор введёт в форме отправки "([^"]*)" и нажмёт кнопку отправки$/) do |email|
  within('#new_user') do
    fill_in("Email", with: email)
    click_button("Отправить")
  end
end

When(/^пользователь получит сообщение на свою почту "([^"]*)"$/) do |user_mail|
  visit('localhost:1080')
  assert page.has_content?(user_mail)
end

When(/^получивший сообщение о регистрации пользователь нажмёт на ссылку о подтверждении$/) do
  pending
end

When(/^он окажется на странице регистрации, где сможет указать свой пароль и имя$/) do
  pending
end