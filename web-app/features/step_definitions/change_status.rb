When(/^он отфильтрует сообщения по статусу "([^"]*)"$/) do |status_title|
  visit(root_path)
  click_link(status_title)
end

When(/^на странице отображены только сообщения с этим статусом$/) do
  page.has_xpath?("//h2[contains(text(), 'Выполенные сообщения')]")
end

When(/^он захочет посмотреть все сообщения$/) do
  visit(root_path)
  click_link('All')
end

When(/^на странице отображены все сообщения с любыми статусами$/) do
  page.has_xpath?("//h2[contains(text(), 'Все сообщения')]")
end
