# Navigation steps
When('I visit the home page') do
  visit root_path
end

When('I visit the people page') do
  visit people_path
end

Given('I am on the people page') do
  visit people_path
end

When('I go back') do
  page.go_back
end

When('I refresh the page') do
  page.refresh
end

Given('I am a visitor to the platform') do
  visit root_path
  # Sign out if currently signed in
  if page.has_text?('Sign out') || page.has_link?('Sign out')
    visit destroy_user_session_path
  end

  expect(page).to have_current_path(root_path)
end
