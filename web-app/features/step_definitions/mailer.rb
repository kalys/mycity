# When(/администратор нажмёт кнопку "([^"]*)"/) do |link|
#   visit(root_path)
#   click_link(link)
# end
#
# When(/^появится выпадающий список в котором есть такие ссылки, как "([^"]*)", "([^"]*)" и "([^"]*)"$/) do |categories, messages, registration|
#   assert page.has_content?(categories)
#   assert page.has_content?(messages)
#   assert page.has_content?(registration)
# end
#
# When(/администратор в выпадающем списке нажмёт на ссылку "([^"]*)"$/) do |link|
#   click_link(link)
# end
#
# When(/он окажется на странице регистрации, где сможет указать электронную почту, на которую нужно отправить приглашение$/) do
#   assert page.current_path == new_user_invitation_path
# end
#
When(/^администратор введёт в форме отправки "([^"]*)" и нажмёт кнопку отправки$/) do |email|
  visit('users/invitation/new')
  within('#new_user') do
    fill_in("Email", with: email)
    sleep(2)
    click_button("Отправить")
    sleep(5)
  end
end

When(/^пользователь получит сообщение на свою почту "([^"]*)"$/) do |user_mail|
  visit('http://localhost:1080')
  sleep(5)
  assert page.has_content?("<#{user_mail}>")
end

When(/^получивший сообщение о регистрации пользователь нажмёт на ссылку о подтверждении$/) do
  visit(root_path)
  sleep(1)
  click_link("Выход")
  sleep(2)
  visit('http://localhost:1080')
  sleep(1)
  find(:xpath, '//tr[@data-message-id=1]').click()
  click_link('#user_id')
  sleep(3)
end

When(/^он окажется на странице регистрации, где сможет указать свой пароль и имя$/) do
  pending
end