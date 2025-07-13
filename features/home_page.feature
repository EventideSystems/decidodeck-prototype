Feature: Home Page
  As a user
  I want to visit the home page
  So that I can see the main dashboard

  Background:
    Given I am signed in as a user

  Scenario: Visiting the home page
    When I visit the home page
    Then I should see "Decidodeck"
    And I should see the current user information

  @javascript
  Scenario: Visiting the home page with JavaScript
    When I visit the home page
    Then I should see "Decidodeck"
    And the page should be fully loaded
