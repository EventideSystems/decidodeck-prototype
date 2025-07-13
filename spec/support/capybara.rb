# frozen_string_literal: true

require 'capybara/rspec'
require 'capybara/cuprite'

# Configure Capybara to use Cuprite (Chrome/Chromium driver)
Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    window_size: [ 1200, 800 ],
    browser_options: {
      'no-sandbox': nil,
      'disable-gpu': nil,
      'disable-dev-shm-usage': nil
    },
    inspector: Rails.env.test?,
    headless: !ENV['HEADLESS'].in?([ nil, '', '0', 'false' ])
  )
end

# Set Cuprite as the JavaScript driver
Capybara.javascript_driver = :cuprite

# Configure Capybara settings
Capybara.configure do |config|
  config.default_max_wait_time = 5
  config.default_selector = :css

  # Set server host and port for CI environments
  config.server_host = '0.0.0.0' if ENV['CI']
  config.server_port = ENV.fetch('CAPYBARA_SERVER_PORT', 3001)

  # Configure app host for system tests
  config.app_host = "http://#{config.server_host}:#{config.server_port}" if ENV['CI']
end

# Add helper methods for feature specs
RSpec.configure do |config|
  # Clean up screenshots after each test (optional)
  config.after(:each, type: :feature) do
    # Cuprite.driver&.reset if Capybara.current_driver == :cuprite
  end

  # Include Capybara DSL in feature specs
  config.include Capybara::DSL, type: :feature
  config.include Capybara::RSpecMatchers, type: :feature
end
