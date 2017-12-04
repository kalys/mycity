When(/^залогинен модератор с email "([^"]*)" и паролем "([^"]*)"$/) do |email, password|
	visit('/users/sign_in')
	within('#new_user') do 
		fill_in('Email', with: email)
		fill_in('Password', with: password)
		click_button('Log in')
	end
end

When(/^он перейдет на страницу с сообщениями чтобы изменить статус сообщения c тесктом "([^"]*)" на done$/) do |body|
  visit(root_path)
  click_link(body)
  find_by_id('collapse0').find("option[value='done']").click
  find_by_id('collapse0').click_button('Обновить статус')
end

When(/^статус сообщения сменится на "([^"]*)"$/) do |status|
	page.has_xpath?("//div[@id='collapse0']//b[contains(text(), '#{status}')]")
end

When(/^он перейдет на страницу с сообщениями и удалит сообщение "([^"]*)"$/) do |message_body|
  visit(root_path)
  click_link(message_body)
  find_by_id('collapse0').click_link('Удалить сообщение')
end

When(/^сообщения "([^"]*)" больше не будет в списке сообщений$/) do |text|
	visit('/messages')
	assert page.has_no_content?(text)
end

When(/^он изменит категорию для сообщения "([^"]*)" на "([^"]*)"$/) do |message_body, category_title|
	visit(root_path)
	sleep 2
	click_link(message_body)
	sleep 2
	find_by_id('collapse0').find('option[value="1"]').click
	sleep 2
	find_by_id('collapse0').click_button('Обновить категорию')
	sleep 2
end

When(/^категория сообщения сменится на "([^"]*)"$/) do |category|
	page.has_xpath?("//div[@id='collapse0']//b[contains(text(), '#{category}')]")
end
