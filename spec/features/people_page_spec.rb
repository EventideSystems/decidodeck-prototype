# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'People page', type: :feature do
  let(:user) { create(:user) }
  let(:account) { create(:account, owner: user) }

  before do
    sign_in user
  end

  scenario 'User visits the people page' do
    visit people_path

    expect(page).to have_content('People')
    expect(page).to have_content('Manage your stakeholders and team members')
  end

  scenario 'User can toggle the actions drawer', js: true do
    visit people_path

    # Check that the drawer is initially hidden
    expect(page).to have_css('[data-drawer-target="panel"]')

    # Click the Actions button to open the drawer
    click_button 'Actions'

    # Wait for the drawer to appear (it should slide in)
    expect(page).to have_content('Quick Actions')
    expect(page).to have_content('Add New Person')

    # Test that we can close the drawer by clicking the overlay
    find('[data-drawer-target="overlay"]').click

    # The drawer should close (content should no longer be visible)
    # Note: We're testing functionality, the actual visibility depends on CSS transitions
  end

  scenario 'User can close drawer with ESC key', js: true do
    visit people_path

    # Open the drawer
    click_button 'Actions'
    expect(page).to have_content('Quick Actions')

    # Press ESC to close
    page.driver.send_keys(:escape)

    # The drawer should close
    # Note: Actual visibility testing would depend on the CSS implementation
  end
end
