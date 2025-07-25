When('I open the welcome message') do
  # Find all matching headings and take the first one
  headings = all('a h1, a h2, a h3', text: /Welcome to Decidodeck/i)
  artifact_link = headings.first.ancestor('a')
  artifact_link.click
end

Then('I should be presented with an overview of the platform\'s features') do
  expect(page).to have_content("Explore your workspace")
  expect(page).to have_content("Create your first artifact")
  expect(page).to have_content("Invite team members")
  expect(page).to have_content("Set up your profile")
end
