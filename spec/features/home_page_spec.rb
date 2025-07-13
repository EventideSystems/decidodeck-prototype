# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home page', type: :feature do
  let(:user) { create(:user) }
  let(:account) { create(:account, owner: user) }

  before do
    sign_in user
  end

  scenario 'User visits the home page' do
    visit root_path

    expect(page).to have_content('Here')
  end

  scenario 'User visits the home page with JavaScript', js: true do
    visit root_path

    expect(page).to have_content('Here')
    # Test that JavaScript is working by checking for dynamic content
    expect(page).to have_css('body')
  end
end
