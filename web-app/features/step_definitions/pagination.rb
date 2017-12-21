When(/^залогинен модератор с email "([^"]*)" и паролем "([^"]*)"$/) do |email, password|
    visit('/users/sign_in')
    within('#new_user') do
        fill_in('Email', with: email)
    fill_in('Пароль', with: password)
    click_button('Войти')
  end
end

When(/^он в списке сообщений перейдет на страницу 3$/) do
    visit('messages/')
    find(:xpath, "//a[@href='/?page=3']").click
end

When(/^его перекинет на страницу 3 где будут отображаться сообщения этой страницы$/) do
    visit('/?page=3')
end
