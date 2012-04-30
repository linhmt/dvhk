Feature: User create new flight
  A user create new assigned flight with
  provided information

Scenario: new flight with authenticated user
    Given I am a new, authenticated user
    When user goes to Actions page
    And click Create Flight
    Then user is redirected to Create Flight form

Scenario: new flight with unauthorised user
    Given a user not logged in
    When user goes to Actions page
    And click Create Flight
    Then user is redirected to Sign In form
