Feature: Collaboration
  As a user
  I want to collaborate with others
  So that we can work together effectively

 Background:
    Given I am signed in as a user

  Scenario: User invites others to collaborate
    Given I am on the collaboration page
    When I invite a user to collaborate
    Then I should see a confirmation message
    And the invited user should receive an email notification


  # Scenario: User accepts an invitation to collaborate
  #   Given I am a user who has been invited to collaborate
  #   When I accept the invitation
  #   Then I should be redirected to the collaboration page
  #   And I should see the project details

  # Scenario: Existing user accepts an invitation to collaborate
  #   Given I am an existing user who has been invited to collaborate
  #   When I accept the invitation
  #   Then I should see a success message
  #   And I should be added to the project

  # Scenario: User declines an invitation to collaborate
  #   Given I am a user who has been invited to collaborate
  #   When I decline the invitation
  #   Then I should see a confirmation message
  #   And I should not be added to the project

  