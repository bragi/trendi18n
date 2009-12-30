Given /^I have translated "([^\"]*)" to "([^\"]*)" in "([^\"]*)" locale$/ do |key, translation, locale|
  Translation.create!(:key => key, :translation => translation, :locale => locale)
end

Given /^I have tranlated "([^\"]*)" to "([^\"]*)" with scope "([^\"]*)" in "([^\"]*)" locale$/ do |key, translation, scope, locale|
  Translation.create!(:key => key, :translation => translation, :locale => locale, :scope => scope)
end

Given /^I have relocalized "([^\"]*)" from "([^\"]*)" to "([^\"]*)"$/ do |key, old_locale, new_locale|
  Translation.first(:conditions => {:key => key, :locale => old_locale}).update_attribute('locale', new_locale)
end

When /^I reloading locales$/ do
  Translation.set_locales
end







