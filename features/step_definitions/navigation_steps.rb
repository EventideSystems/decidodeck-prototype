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
