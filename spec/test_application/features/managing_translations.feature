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

Scenario: List of translation in current locale
    Given I have translated "Key1" to "Key1Translation" in "en" locale
    And I have translated "Key1" to "Klucz1Tłumaczenie" in "pl" locale
    When I go to the list of polish translations
    Then I should see "Klucz1Tłumaczenie"
    And I should not see "Key1Translation"

Scenario: Adding new translation
    When I go to the list of translations
    And I follow "New translation"
    Then I should be on the new translation form
    When I fill in "translation[key]" with "New translation"
    And I fill in "translation[translation]" with "New translation is translated"
    And I press "Create"
    Then I should be on the list of translations
    And I should see "Translation created!"
    And I should see "New translation"
    And I should see "New translation is translated"

Scenario: Editing translations
    Given I have translated "Key1" to "Key1Translation" in "en" locale
    When I go to the list of translations
    And I follow "Edit translation"
    Then I should be on the edit translation form
    And I fill in "translation[translation]" with "Key1NewTranslation"
    And I fill in "translation[many]" with "Key1Many"
    And I press "Save"
    Then I should be on the list of translations
    And I should see "Translation updated"
    And I should not see "Key1Translation"
    And I should see "Key1NewTranslation"
    And I should see "Key1Many"


