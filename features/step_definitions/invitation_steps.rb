# Given('I am a user who has been invited to collaborate') do
#   # This step encapsulates the entire invitation scenario
#   step 'I am signed in as a user'
#   step 'I have a workspace with projects'
#   step 'another user invites me to collaborate'
#   step 'I receive an invitation email'
# end

Given('I am on the collaboration page') do
  visit new_user_invitation_path
end

When('I invite a user to collaborate') do
  fill_in 'Email', with: 'invitee@example.com'
  click_button 'Invite collaborator'
end

Then('I should see a confirmation message') do
  pending # Write code here that turns the phrase above into concrete actions
end

Then('the invited user should receive an email notification') do
  pending # Write code here that turns the phrase above into concrete actions
end
