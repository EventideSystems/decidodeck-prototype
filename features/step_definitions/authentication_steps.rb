# Authentication steps
Given('I am signed in as a user') do
  @user = create(:user)
  @account = create(:account, owner: @user)

  # Use Capybara to sign in through the UI for feature tests
  visit new_user_session_path
  fill_in 'Email', with: @user.email
  fill_in 'Password', with: 'password123'

  # Try different possible button texts
  if page.has_button?('Sign in')
    click_button 'Sign in'
  elsif page.has_button?('Log in')
    click_button 'Log in'
  elsif page.has_button?('Submit')
    click_button 'Submit'
  else
    # Find any submit button
    find('input[type="submit"]').click
  end
end

Given('I am signed out') do
  visit destroy_user_session_path
end

Then('I should be signed in') do
  expect(page).not_to have_content('Sign in')
end

Then('I should be signed out') do
  expect(page).to have_content('Sign in')
end
