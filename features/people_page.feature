Feature: People Page
  As a user
  I want to manage people and stakeholders
  So that I can organize my project contacts

  Background:
    Given I am signed in as a user

  Scenario: Viewing the people page
    When I visit the people page
    Then I should see "People"
    And I should see "Manage your stakeholders and team members"

  @javascript
  Scenario: Opening and closing the actions drawer
    Given I am on the people page
    When I click the "Actions" button
    Then the actions drawer should open
    And I should see "Quick Actions"
    And I should see "Add Individual"
    When I click the overlay
    Then the actions drawer should close

  @javascript
  Scenario: Closing the drawer with ESC key
    Given I am on the people page
    When I click the "Actions" button
    Then the actions drawer should open
    When I press the ESC key
    Then the actions drawer should close

  @javascript
  Scenario: Using the drawer tab to toggle
    Given I am on the people page
    When I click the drawer tab
    Then the actions drawer should open
    When I click the drawer tab again
    Then the actions drawer should close
