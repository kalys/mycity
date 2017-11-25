When(/^залогинен модератор с email "([^"]*)" и паролем "([^"]*)"$/) do |email, password|
	visit('/users/sign_in')
	within('#new_user') do 
		fill_in('Email', with: email)
		fill_in('Password', with: password)
		click_button('Log in')
	end
end

When(/^он перейдет на страницу с сообщениями чтобы изменить статус сообщения на hidden$/) do
  visit(root_path)
	find_by_id('message_status').find("option[value='done']").click
  click_button('Обновить статус')
end

When(/^статус сообщения сменится на "([^"]*)"$/) do |status|
	page.has_xpath?("//b[contains(text(), '#{status}')]")
end

When(/^он перейдет на страницу с сообщениям и нажмет на "([^"]*)"$/) do |title|
  visit(root_path)
	click_link('Удалить сообщение')
	sleep 3
end

When(/^сообщения "([^"]*)" больше не будет в списке сообщений$/) do |text|
  # expect(page).to have_no_content(text)
  # expect(page).not_to have_content(text)
	page.should_not( have_content(text))
end