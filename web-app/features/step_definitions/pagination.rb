When(/^он в списке сообщений перейдет на страницу 3$/) do
    visit('messages/')
    find(:xpath, "//a[@href='/?page=3']").click
end

When(/^его перекинет на страницу 3 где будут отображаться сообщения этой страницы$/) do
    visit('/?page=3')
end
