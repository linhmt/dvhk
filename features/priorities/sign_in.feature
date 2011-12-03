Feature: Access Priorities
  In order to get access to protected sections of the site
  A user
  Should be redirect to sign in and view all available resources

    Scenario: User is not signed in and try to access all Priorities
      Given I am not signed in
      When I go to list all Priorities
      Then I should see "You need to sign in before continuing"

    