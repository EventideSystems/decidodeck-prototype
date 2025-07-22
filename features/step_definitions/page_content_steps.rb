# Page content steps
Then('I should see {string}') do |text|
  expect(page).to have_content(text)
end

Then('I should not see {string}') do |text|
  expect(page).not_to have_content(text)
end

Then('I should see the current user information') do
  expect(page).to have_content(@user.short_name)
end

Then('the page should be fully loaded') do
  expect(page).to have_css('body')
  expect(page).to have_css('html')
end

Then('I should see a {string} button') do |button_text|
  expect(page).to have_button(button_text)
end

Then('I should see a {string} link') do |link_text|
  expect(page).to have_link(link_text)
end
