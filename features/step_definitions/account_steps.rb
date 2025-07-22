Given('I have not yet created an account') do
  @user = build(:user)
  expect(User.exists?(email: @user.email)).to be_falsey
end

When('I enter my registration details') do
  visit new_user_registration_path

  fill_in 'Email', with: @user.email
  fill_in 'Password', with: 'password123'
  fill_in 'Password confirmation', with: 'password123'

  # Fill in additional fields if they exist in the form
  if page.has_field?('First name')
    fill_in 'First name', with: @user.first_name
  end

  if page.has_field?('Last name')
    fill_in 'Last name', with: @user.last_name
  end

  if page.has_field?('Name')
    fill_in 'Name', with: "#{@user.first_name} #{@user.last_name}"
  end
  click_button 'Sign up'
end

When('I verify my email') do
  unconfirmed_user = User.find_by(email: @user.email)
  # Assuming the email verification link is sent to the user's email
  # In a real test, you would mock the email sending and directly visit the verification link
  visit user_confirmation_path(confirmation_token: unconfirmed_user.confirmation_token)
end

When('I log into the platform for the first time') do
  visit new_user_session_path
  fill_in 'Email', with: @user.email
  fill_in 'Password', with: 'password123'
  click_button 'Log in'
end

Then('I will be presented with a welcome message and an invitation to select a role in Decidodeck') do
  expect(page).to have_content('Welcome to Decidodeck')
  expect(page).to have_content('Please select a role to continue')
end
