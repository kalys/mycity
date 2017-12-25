# Предыстория
When(/^залогинен модератор с email "([^"]*)" и паролем "([^"]*)"$/) do |email, password|
	visit('/users/sign_in')
	within('#new_user') do
		fill_in('Email', with: email)
    fill_in('Пароль', with: password)
    click_button('Войти')
  end
end

When(/^он находится на главной странице$/) do
  visit(root_path)
end

When(/^он нажмет на кнопку "([^"]*)" у сообщения "Тестовое сообщение"$/) do |title|
  find_by_id('message_0').click_link(title)
end

# Общие шаги
When(/^он увидит сообщение "([^"]*)"$/) do |title|
  page.has_xpath?("//div[contains(text(), title)]")
end

When(/^нажмет на кнопку "([^"]*)"$/) do |title|
  click_button(title)
end

# Смена статуса у сообщения
When(/^на странице редактирования он сменит статус сообщения на "([^"]*)"$/) do |title|
  find("option[value='done']").click
end

When(/^статус сообщения сменится на "([^"]*)"$/) do |status|
  page.has_xpath?("//b[contains(text(), status)]")
end

# Удаление сообщения
When(/^на странице редактирования он нажмет на кнопку "([^"]*)"$/) do |title|
  click_link(title)
end

When(/^на странице с сообщениями больше не будет сообщения "([^"]*)"$/) do |title|
  assert page.has_no_content?(title)
end

# Изменение категории
When(/^на странице редактирования он изменит категорию на "([^"]*)"$/) do |category_title|
  find('option[value="1"]').click
end

When(/^категория сообщения сменится на "([^"]*)"$/) do |category_title|
	page.has_xpath?("//b[contains(text(), category_title)]")
end
