Feature: Static translation
  In order to understand the web page
  As a language idiot
  I want to be given static page elements in a selected language

Scenario: Simple translations test
    Given I have translated "Key1" to "Key1Translation" in "en" locale
    And I have tranlated "Key2" to "Key2Translation" with scope "scope1.subscope1" in "en" locale
    And I have translated "Key3" to "Klucz3Tłumaczenie" in "pl" locale
    When I go to the translations test page
    Then I should see "Key1Translation"
    And I should see "Key2Translation"
    And I should see "Klucz3Tłumaczenie"