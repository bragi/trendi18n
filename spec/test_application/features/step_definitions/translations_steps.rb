Given /^I have translated "([^\"]*)" to "([^\"]*)" in "([^\"]*)" locale$/ do |key, translation, locale|
  Translation.create!(:key => key, :translation => translation, :locale => locale)
end

Given /^I have tranlated "([^\"]*)" to "([^\"]*)" with scope "([^\"]*)" in "([^\"]*)" locale$/ do |key, translation, scope, locale|
  Translation.create!(:key => key, :translation => translation, :locale => locale, :scope => scope)
end





