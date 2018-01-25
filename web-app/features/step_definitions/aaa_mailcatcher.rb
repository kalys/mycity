When(/^войти в м-кетчер и нажать на кнопку очистки$/) do
  visit('http://localhost:1080')
  sleep(3)
  accept_alert do
    click_link('Clear')
  end
  sleep(3)
end

When(/^будет норм$/) do
  puts "Норм :D"
end