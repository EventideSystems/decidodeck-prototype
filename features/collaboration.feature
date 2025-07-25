Feature: Collaboration
  As a user
  I want to collaborate with others
  So that we can work together effectively

  Scenario: User invites others to collaborate
    Given I am on the collaboration page
    When I invite a user to collaborate
    Then I should see a confirmation message
    And the invited user should receive an email notification