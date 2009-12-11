module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name
    
    when /the home\s?page/
      '/'
    when /the list of translations/
      translations_path
    
    when /the list of unfinished translations/
      translations_path :condition => "untranslated"
    when /the list of finished translations/
      translations_path :condition => "translated"
    when /the list of polish translations/
      translations_path :localization => "pl"
    when /the new translation form/
      new_translation_path
    when /the edit translation form/
      edit_translation_path
    when /the translations test page/
      translation_path :id => 1
    
    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
