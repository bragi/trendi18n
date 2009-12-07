Feature: Managing translations
  In order to have more free time
  As a clever developer
  I want to be able to manage all translations through a Translation model

Scenario: List of translations
    Given I have translated "Key1" to "Key1Translation" in "en" locale
    And I have translated "Key2" to "Key2Translation" in "en" locale
    When I go to the list of translations
    Then I should see "Key1"
    And I should see "Key1Translation"
    And I should see "Key2"
    And I should see "Key2Translation"

Scenario: List of finished translations
    Given I have translated "Key1" to "Key1Translation" in "en" locale
    And I have translated "Key2" to "" in "en" locale
    When I go to the list of finished translations
    Then I should see "Key1"
    And I should not see "Key2"

Scenario: List of unfinished translations
    Given I have translated "Key1" to "Key1Translation" in "en" locale
    And I have translated "Key2" to "" in "en" locale
    When I go to the list of unfinished translations
    Then I should see "Key2"
    And I should not see "Key1"

