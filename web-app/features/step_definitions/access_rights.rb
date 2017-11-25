When(/^залогинен администратор с email "([^"]*)" и паролем "([^"]*)"$/) do |email, password|
	visit('/users/sign_in')
	within('#new_user') do 
		fill_in('Email', with: email)
		fill_in('Password', with: password)
		click_button('Log in')
	end
end

When(/^он перейдет на страницу добавления прав и заполнит поля данными:$/) do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  # table.hashes[0][:category]
	visit('/admin/roles/new')
	within('#new_role') do
		fill_in('role[name]', with: table.hashes[0][:name])
		fill_in('role[title]', with: table.hashes[0][:title])
		fill_in('role[description]', with: table.hashes[0][:description])
		click_button('Create new Role')
	end
end

When(/^появляется надпись "([^"]*)"$/) do |title|
	page.has_xpath?("//*[@id='toast-container']//div[contains(text(), '#{title}')]")
end


When(/^администратор находится в управлении группой модераторы$/) do 
	visit('/admin/roles/2/edit')	
end

When(/^он добавит доступ к странице "([^"]*)"$/) do |title|
	within(:xpath, "//form[@id='new_section']") do 
		fill_in('section_name', with: title)
		click_button('Create new section')
	end
end

When(/^появится надпись "([^"]*)"$/) do |title|
	page.has_xpath?("//*[@id='toast-container']//div[contains(text(), '#{title}')]")
end

When (/^залогинен пользователь с email "([^"]*)" и паролем "([^"]*)" и он попытается зайти в админку$/) do |email, password|
	visit(root_path)
	click_link('Logout')
	visit('/users/sign_in')
	within('#new_user') do 
		fill_in('Email', with: email)
		fill_in('Password', with: password)
		click_button('Log in')
	end
	visit('/admin/roles')
end

When(/^его переадресует на страницу с ошибкой "([^"]*)"$/) do |error_title|
	page.has_xpath?("//h1[contains(text(), '#{error_title}')]")
