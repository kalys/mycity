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
    fill_in("user_email", with: email)
    click_button("Отправить инструкцию по восстановлению пароля")
  end
end

When(/^пользователь получит сообщение на свою почту <moder@moder.ru>$/) do
  visit('http://localhost:1080')
  find(:xpath, '//td[contains(text(), "<moder@moder.ru>")]')
end

When(/^получивший сообщение о восстановлении пароля пользователь нажмёт на ссылку о подтверждении$/) do
  visit('http://localhost:1080')
  find(:xpath, '//td[contains(text(), "<moder@moder.ru>")]').click
  within_frame(find('.body')) do
    find_link("Change my password").click
    sleep 20
  end
end

When(/^он окажется на странице восстановлении пароля, где сможет указать себе новый пароль$/) do
  # visit('http://localhost:1080')
  # find(:xpath, '//td[contains(text(), "<moder@moder.ru>")]').click
  # within_frame(find('.body')) do
  #   find_link("Change my password").click
  # end
  # sleep 2
  find(:xpath, '//*[contains(text(), "Измените свой пароль")]')
  # within('#new_user') do
  #   fill_in(" Новый пароль", with: "qweqweqwe")
  #   fill_in(" Подтвердите свой пароль", with: "qweqweqwe")
  #   click_button("Поменять пароль")
  #   sleep 3
  # end
end
