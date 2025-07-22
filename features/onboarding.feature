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
    Then I will be presented with a welcome message and an invitation to select a role in Decidodeck

 # Scenario: First-time user begins orientation

    # and I will be presnted with a choice of facilitation roles:
    #   | Role        |
    #   | Observer    |
    #   | Driftwalker |
    #   | Contributor |
    # And I engage with the onboarding sequence, which includes:
    #   | Orientation to Decidodeck's glyph-based interface |
    #   | Overview of collaborative workflows and emotional mapping tools |
    #   | Option to co-create or join an existing Theory of Change thread |
    # And my profile is set up with strategic preferences and emotional attunement tags
    # And I am ready to start collaborating meaningfully on system rituals and strategic models

  # Background:
  #   Given I am a new user

  # Scenario: Completing the onboarding process
  #   When I start the onboarding process
  #   Then I should see "Welcome to Decidodeck"
  #   And I should see "Let's get started"  

