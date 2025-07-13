# Drawer-specific steps
When('I click the overlay') do
  find('[data-drawer-target="overlay"]').click
end

When('I click the drawer tab') do
  find('[data-drawer-target="tab"] button').click
end

When('I click the drawer tab again') do
  find('[data-drawer-target="tab"] button').click
end

Then('the actions drawer should open') do
  # Wait for the drawer to slide in and become visible
  expect(page).to have_content('Quick Actions', wait: 3)
end

Then('the actions drawer should close') do
  # The drawer content should not be visible when closed
  # We can check if the overlay is no longer visible/active
  expect(page).to have_css('[data-drawer-target="overlay"].opacity-0', wait: 3)
end

Then('I should see the drawer tab') do
  expect(page).to have_css('[data-drawer-target="tab"]')
end

Then('the drawer tab should show {string} arrow') do |direction|
  # This would test the arrow direction in the tab
  case direction.downcase
  when 'left'
    expect(page).to have_css('[data-drawer-target="icon"] path[d*="M15 19l-7-7 7-7"]')
  when 'right'
    expect(page).to have_css('[data-drawer-target="icon"] path[d*="M9 5l7 7-7 7"]')
  end
end
