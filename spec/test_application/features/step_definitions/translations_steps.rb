Given /^I have translated "([^\"]*)" to "([^\"]*)" in "([^\"]*)" locale$/ do |key, translation, locale|
  Translation.create!(:key => key, :translation => translation, :locale => locale)
end




