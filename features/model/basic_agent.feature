Feature: All work within kamikaze is performed by agents.
  Since agents are important to work being done then an agent
  needs to have a base level of competancy so that not a lot
  of programmer time needs to be spent recreating things.

  Scenario: An agent should be able to dress itself with information
    Given an agent has been created
    When an agent is given an outfit 'basic-outfit' to wear
    Then the agent will look like outfit 'basic-outfit'
