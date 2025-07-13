# Interaction steps
When('I click {string}') do |element|
  click_on element
end

When('I click the {string} button') do |button_text|
  click_button button_text
end

When('I click the {string} link') do |link_text|
  click_link link_text
end

When('I fill in {string} with {string}') do |field, value|
  fill_in field, with: value
end

When('I select {string} from {string}') do |value, field|
  select value, from: field
end

When('I check {string}') do |field|
  check field
end

When('I uncheck {string}') do |field|
  uncheck field
end

When('I press the ESC key') do
  # Send ESC key to the document body to avoid coordinate issues
  find('body').send_keys(:escape)
end

When('I press the ENTER key') do
  # Send ENTER key to the document body
  find('body').send_keys(:return)
end
