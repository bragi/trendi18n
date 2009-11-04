require 'spec_helper'

describe UsersController do

  #Delete this example and add some real ones
  it "should use UsersController" do
    controller.should be_an_instance_of(UsersController)
  end

  it "should assign dupa to variable" do
    var = I18n.translate :hello
    var.should == "dupa"
  end

end
