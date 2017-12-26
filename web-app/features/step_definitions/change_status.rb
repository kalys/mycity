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
