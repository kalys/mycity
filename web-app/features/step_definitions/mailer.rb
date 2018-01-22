When(/администратор нажмёт кнопку "([^"]*)"/) do |link|
  visit(root_path)
  click_link(link)
end

When(/^появится выпадающий список в котором есть такие ссылки, как "([^"]*)", "([^"]*)" и "([^"]*)"$/) do |categories, messages, registration|
  assert page.has_content?(categories)
  assert page.has_content?(messages)
  assert page.has_content?(registration)
end

When(/администратор в выпадающем списке нажмёт на ссылку "([^"]*)"$/) do |link|
  click_link(link)
end

When(/он окажется на странице регистрации, где сможет указать электронную почту, на которую нужно отправить приглашение$/) do
  assert page.current_path == new_user_invitation_path
end

When(/^администратор введёт в форме отправки "([^"]*)" и нажмёт кнопку отправки$/) do |email|
  visit('users/invitation/new')
  within('#new_user') do
    fill_in("user_email", with: email)
    click_button("Отправить")
  end
end

When(/^пользователь получит сообщение на почту "([^"]*)"$/) do |user_mail|
  visit('http://localhost:1080')
  assert page.has_content?("<#{user_mail}>")
end
new_window = nil

When(/^получивший сообщение о регистрации пользователь нажмёт на ссылку о подтверждении$/) do
  visit(root_path)
  click_link("Выход")
  visit('http://localhost:1080')
  find(:xpath, '//tr[@data-message-id=1]').click()
  registration_link = nil
  within_frame(find('.body')) do
    registration_link = find(:xpath, '//*[@id="user_id"]')[:href]
  end
  new_window = window_opened_by { visit(registration_link) }
  visit(registration_link)
end

# When(/^он окажется на странице регистрации, где сможет указать свой пароль и имя$/) do
#   within_window new_window do
#     within('#edit_user') do
#       fill_in("Имя", with: "Somename")
#       fill_in("Пароль", with: "qweqweqwe")
#       fill_in("Подтверждение пароля", with: "qweqweqwe")
#       click_button("Сохранить")
#     end
#   end
#
# end
