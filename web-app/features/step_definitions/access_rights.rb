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


When(/^администратор находится в управлении группой "([^"]*)"$/) do |title|
	visit('/users/sign_in')
	within('#new_user') do 
		fill_in('Email', with: 'admin@admin.ru')
		fill_in('Password', with: 'qweqweqwe')
		click_button('Log in')
	end
	visit('/admin/roles/2/edit')	
	sleep 3
end

When(/^он добавит доступ к странице "([^"]*)"$/) do |title|
	sleep 3
	within(:xpath, "//form[@id='new_section']") do 
		fill_in('section_name', with: title)
		sleep 3
		click_button('Create new section')
		sleep 3
	end
end

When(/^появится надпись "([^"]*)"$/) do |title|
	sleep 3
	page.has_xpath?("//*[@id='toast-container']//div[contains(text(), '#{title}')]")
	sleep 3
end

		# Допустим администратор заходит в управление группой "тест"
		# Если он добавит доступ к странице "messages"
		# То появляется надпись "Section created"