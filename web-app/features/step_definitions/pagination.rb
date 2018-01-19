When(/^он в списке сообщений перейдет на страницу 2$/) do
    visit('messages/')
    find_by_id('next_page').click
end

When(/^его перекинет на страницу 2 где будут отображаться сообщения этой страницы$/) do
    visit('/?page=2')
end
