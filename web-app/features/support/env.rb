require 'cucumber/rails'

ActionController::Base.allow_rescue = false

begin
	DatabaseCleaner.clean_with(:truncation)
  DatabaseCleaner.strategy = :transaction
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end

Cucumber::Rails::Database.javascript_strategy = :truncation

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Capybara.javascript_driver = :chrome

Before do |scenario|
  load Rails.root.join('db/seeds.rb')
end
