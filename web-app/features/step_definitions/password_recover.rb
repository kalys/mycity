When(/и нажмет на ссылку "([^"]*)"/) do |button|
  visit(root_path)
  click_button(button)
end

When(/^он попадет на страницу восстановления пароля которая озаглавлена "([^"]*)"$/) do |page_header|
  assert page.has_content?(page_header)
end

When(/^пользователь введёт в форме отправки "([^"]*)" и нажмёт кнопку отправки$/) do |email|
  within('#user_email') do
    fill_in("Email", with: email)
    click_button("Отправить инструкцию по восстановлению пароля")
  end
end

When(/^пользователь получит сообщение на свою почту "([^"]*)"$/) do |user_mail|
  visit('localhost:1080')
  assert page.has_content?(user_mail)
end
