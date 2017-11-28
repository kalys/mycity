When(/^залогинен пользователь с email "([^"]*)" и паролем "([^"]*)"$/) do |email, password|
	visit('/users/sign_in')
	within('#new_user') do
		fill_in('Email', with: email)
		fill_in('Password', with: password)
		click_button('Log in')
	end
end

When(/^он создает категорию с данными:$/) do |table|
	visit('/categories/new')
		within('#new_category') do
		fill_in('Title', with: table.hashes[0][:title])
		click_button('Create Category')
	end
	visit('/categories')
end

When(/^категория "([^"]*)" видна в списке категорий$/) do |title|
	page.has_xpath?("//table[@id='index_table_categories']//a[contains(text(), '#{title}')]")
end

When(/^он обновляет категорию "([^"]*)" на:$/) do |title, table|
	visit('/categories')
	page.find_by_id('edit_category_1').click
	within('#edit_category_1') do
		fill_in('Title', with: table.hashes[0][:title])
		click_button('Update Category')
	end
end

When(/^категория "([^"]*)" меняет название на asd$/) do |title|
	page.has_xpath?("//table[@id='index_table_categories']//a[contains(text(), '#{title}')]")
end

When(/^он удаляет категорию "([^"]*)"$/) do |title|
	visit('/categories')	
	page.find_by_id('archiving_category_1').click
	assert page.has_no_content?(title)
end

When(/^категории больше нет в списке категорий$/) do
	visit('/categories')	
	assert page.has_no_content?("Тестовая категория")
end

When(/^она появляется в списке архивированных категорий$/) do
	visit('/categories/archived_categories')	
	assert page.has_content?("Тестовая категория")
end

When(/^он восстанавливает категорию "([^"]*)"$/) do |title|
	visit('/categories')
	page.find_by_id('archiving_category_1').click
	visit('/categories/archived_categories')	
	page.find_by_id('unarchiving_category_1').click
end

When(/^категория пропадает в списке архивированных и появляется в списке активных категорий$/) do
	visit('/categories/archived_categories')	
	assert page.has_no_content?("Тестовая категория")
	visit('/categories')
	assert page.has_content?("Тестовая категория")
end