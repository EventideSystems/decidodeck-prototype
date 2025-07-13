# frozen_string_literal: true

require 'database_cleaner'

DatabaseCleaner.allow_remote_database_url = true

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    # Use truncation strategy for feature tests that use JavaScript
    DatabaseCleaner.strategy = :truncation if Capybara.current_driver != Capybara.default_driver
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
