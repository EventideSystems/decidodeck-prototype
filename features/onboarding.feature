Feature: Onboarding
  As a new user
  I want to complete the onboarding process
  So that I can start using the application effectively
  
  Background:
    Given I am a new user

  Scenario: Completing the onboarding process
    When I start the onboarding process
    Then I should see "Welcome to Decidodeck"
    And I should see "Let's get started"  
