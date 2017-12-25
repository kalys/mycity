  # Сценарий: Фильтрация сообщений по статусу "Новое"
  #   Допутим он находится на главной странице
  #   Если он перейдет по ссылке "Новые" в верхней панели страницы
  #   То на странице будут отображены только сообщения со статусом "new_message"

  # Сценарий: Фильтрация сообщений по статусу "Выполненные"
  #   Допутим он находится на главной странице
  #   Если он перейдет по ссылке "Выполненные" в верхней панели страницы
  #   То на странице будут отображены только сообщения со статусом "done"

  # Сценарий: Фильтрация сообщений по статусу "Актуальные"
  #   Допутим он находится на главной странице
  #   Если он перейдет по ссылке "Актуальные" в верхней панели страницы
  #   То на странице будут отображены только сообщения со статусом "actual"

  # Сценарий: Фильтрация сообщений по статусу "Неактуальные"
  #   Допутим он находится на главной странице
  #   Если он перейдет по ссылке "Неактуальные" в верхней панели страницы
  #   То на странице будут отображены только сообщения со статусом "not_relevant"

When(/^он перейдет по ссылке "([^"]*)" в верхней панели страницы$/) do |title|
  click_link(title)
end

When(/^на странице будут отображены только сообщения со статусом "([^"]*)"$/) do |title|
  case title
  when "for_moderaion"
    assert page.has_no_content?("done")
    assert page.has_no_content?("actual")
    assert page.has_no_content?("not_relevant")
  when "done"
    assert page.has_no_content?("for_moderaion")
    assert page.has_no_content?("actual")
    assert page.has_no_content?("not_relevant")
  when "actual"
    assert page.has_no_content?("done")
    assert page.has_no_content?("for_moderaion")
    assert page.has_no_content?("not_relevant")
  when "not_relevant"
    assert page.has_no_content?("done")
    assert page.has_no_content?("actual")
    assert page.has_no_content?("for_moderaion")
  end
end

# When(/^он отфильтрует сообщения по статусу "([^"]*)"$/) do |status_title|
#   visit(root_path)
#   click_link(status_title)
# end

# When(/^на странице отображены только сообщения с этим статусом$/) do
#   page.has_xpath?("//h2[contains(text(), 'Выполенные сообщения')]")
# end

# When(/^он захочет посмотреть все сообщения$/) do
#   visit(root_path)
#   click_link('All')
# end

# When(/^на странице отображены все сообщения с любыми статусами$/) do
#   page.has_xpath?("//h2[contains(text(), 'Все сообщения')]")
# end
