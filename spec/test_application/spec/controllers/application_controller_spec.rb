require 'spec_helper'

describe ApplicationController do

  #Delete this example and add some real ones
  it "should use ApplicationController" do
    controller.should be_an_instance_of(ApplicationController)
  end

  # This test is checking create command of trendi18n generator
  it "generator should install migration" do
    system "ruby script/generate trendi18n"
    File.exist_any?(File.join("db", "migrate", "*.rb"), ActiveRecord::Base.pluralize_table_names ? /create_translations\.rb$/ : /create_translation\.rb$/).should == true
    ActiveRecord::Migrator.new(:up, "db").migrated.include?(File.get_migration_version_from_file_name(ActiveRecord::Base.pluralize_table_names ? /create_translations\.rb$/ : /create_translation\.rb$/)).should == true  
  end

  # This test is checking destroy command of trendi18n generator
  it "generator should remove migration" do
    version = File.get_migration_version_from_file_name(ActiveRecord::Base.pluralize_table_names ? /create_translations\.rb$/ : /create_translation\.rb$/)
    system "ruby script/destroy trendi18n"
    File.exist_any?(File.join("db", "migrate", "*.rb"), ActiveRecord::Base.pluralize_table_names ? /create_translations\.rb$/ : /create_translation\.rb$/).should == false
    ActiveRecord::Migrator.new(:up, "db").migrated.include?(version).should == false

  end

end
