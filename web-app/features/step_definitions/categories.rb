When(/^залогинен администратор с почтой "([^"]*)" и паролем "([^"]*)"$/) do |email, password|
  visit('/users/sign_in')
  within('#new_user') do
    fill_in('Email', with: email)
    fill_in('Пароль', with: password)
    click_button('Войти')
  end
end

When(/^он создает категорию с данными:$/) do |table|
  visit('/categories/new')
    within('#new_category') do
    fill_in('Название', with: table.hashes[0][:title])
    click_button('Создать')
  end
  visit('/categories')
end

When(/^категория "([^"]*)" видна в списке категорий$/) do |title|
  page.has_xpath?("//table[@id='index_table_categories']//a[contains(text(), '#{title}')]")
end

When(/^он обновляет категорию "([^"]*)" на:$/) do |title, table|
  visit('/categories')
  within('tr', text: title) do
    click_link('Обновить')
  end

  fill_in('Название', with: table.hashes[0][:title])
  click_button('Создать')
end

When(/^он создает категорию с пустыми данными:$/) do |table|
  visit('/categories/new')
    within('#new_category') do
      fill_in('Название', with: table.hashes[0][:title])
      click_button('Создать')
    end
end

When(/^его выкинет на страницу категорий$/) do
  visit('/categories')
end


When(/^категория "([^"]*)" меняет название на asd$/) do |title|
  page.has_xpath?("//table[@id='index_table_categories']//a[contains(text(), '#{title}')]")
end

When(/^он удаляет категорию "([^"]*)"$/) do |title|
  visit('/categories')
  page.find_by_id('archiving_category_2').click
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

When(/^он обновляет категорию "([^"]*)" c пустыми данными:$/) do |title, table|
  visit('/categories')
    page.find_by_id('edit_category_1').click
    within('#edit_category_1') do
      fill_in('Название', with: table.hashes[0][:title])
      click_button('Создать')
    end
end

When(/^его выкинет на страницу категорий где "([^"]*)" не изменится$/) do |title|
  page.has_xpath?("//table[@id='index_table_categories']//a[contains(text(), '#{title}')]")
end

When(/^он нажимает на категорию "([^"]*)"$/) do |title|
  visit('/categories')
  page.find_by_id('category_2').click
end

When(/^отображены только сообщения этой категории$/) do
  visit('/categories/2')
end


When(/^модератор попытается создать категорию с пустым названием$/) do
  visit('categories/new')
  within('#new_category') do
    click_button('Создать')
  end
end

When(/^на экране появится фраза "([^"]*)", а под ней "([^"]*)" и в самом низу "([^"]*)"$/) do |main_warning, title, second_warning|
  assert page.has_content?(main_warning)
  assert page.has_content?(title)
  assert page.has_content?(second_warning)
end
