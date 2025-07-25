Feature: Onboarding
  As a new user
  I want to complete the onboarding process
  So that I can begin contributing to strategic work and collaborate effectively with others

  Scenario: First-time user signs up 
    Given I am a visitor to the platform  
    And I have not yet created an account
    When I enter my registration details  
    And I verify my email  
    And I log into the platform for the first time  
    Then I should be presented with a welcome message

  @javascript
  Scenario: First-time user begins orientation
    Given I am signed in as a new user
    When I open the welcome message
    Then I should see "Welcome to Decidodeck"
    And I should be presented with an overview of the platform's features

