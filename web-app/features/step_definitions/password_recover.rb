When(/польователь перейдет на страницу входа и нажмет на ссылку "([^"]*)"/) do |link|
  visit(root_path)
  click_link(link)
end

When(/^он попадет на страницу восстановления пароля которая озаглавлена "([^"]*)"$/) do |page_header|
  assert page.has_content?(page_header)
end

When(/^пользователь введёт в форме отправки "([^"]*)" и нажмёт кнопку отправки$/) do |email|
  visit('users/password/new')
  within('#new_user') do
    sleep(5)
    fill_in("user_email", with: email)
    sleep(2)
    click_button("Отправить инструкцию по восстановлению пароля")
    sleep(5)
  end
end

When(/^пользователь получит сообщение на свою почту "([^"]*)"$/) do |user_mail|
  visit('http://localhost:1080')
  sleep(5)
  assert page.has_content?("<#{user_mail}>")
end

When(/^получивший сообщение о восстановлении пароля пользователь нажмёт на ссылку о подтверждении$/) do
  sleep(5)
  visit('http://localhost:1080')
  sleep(1)
  find(:xpath, '//tr[@data-message-id=1]').click()
  within_frame(find('.body')) do
    find(:xpath, '//*[@id="reset_password"]').click()
  end
  sleep(3)
end

When(/^он окажется на странице восстановлении пароля, где сможет указать себе новый пароль$/) do
  pending
end
