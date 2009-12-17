require File.dirname(__FILE__) + '/../spec_helper'

describe Translation do
  before(:all) do
    @valid_attributes = {
      :locale => "en",
      :key => "test",
      :scope =>"TestScope",
      :default => "test",
      :translation => "test_transation",
      :zero => "non test",
      :one => "one test",
      :few => "few test",
      :many => "many test"
    }
  end


  describe "state assigment" do

    before do
       @state_test_attributes = [
      {:locale => "en",
        :key => "state_test1",
        :default => "default1"
      },
      {:locale => "en",
       :key => "state_test2",
       :translation => "translation2"
      },
      {:key => "status_test3 {{count}}",
       :translation => "translation3",
       :one => "one_translation3"
      },
      { :key => "state_test4 {{count}}",
        :translation => "translation4",
        :one => "one_translation4",
        :zero => "zero_translation4",
        :many => "many_translation4"
      }
    ]

    @state_test_results = ["new", "finished", "unfinished", "finished"]
    end

    it "should assign state to new created model" do
      for data in @state_test_attributes do
        model = Translation.new(data)
        model.save!
        model.state.should == @state_test_results[@state_test_attributes.index(data)]
      end
    end

  end

  it "should lookup for new translations" do
    translation_new = Translation.lookup("en", "key", nil, "scope")
    translation_new.default.should == "key"
    translation_exists = Translation.lookup("en", "key", nil, "scope")
    translation_exists.should == translation_new
  end

  it "should be with count" do
    Translation.new(:key => "I have {{count}} plural forms").with_count?.should_not == nil
  end

  it "should not be with count" do
    Translation.new(:key => "I do not have count").with_count?.should == nil
  end

  it "should create translation with correct scope when translation is missing on lookup" do
    Translation.lookup(:en, :some_key, nil, [:scope, :subscope])
    Translation.find_by_key_and_scope("some_key", "scope.subscope").should_not == nil
  end

  it "should not save translations with not properly attributes" do
    Translation.new(@valid_attributes.merge(:key => nil)).save.should == false
    Translation.new(@valid_attributes.merge(:locale => "p")).save.should == false
    Translation.new(@valid_attributes.merge(:locale => "too long locale")).save.should == false
    Translation.create!(@valid_attributes)
    Translation.new(@valid_attributes).save.should == false
  end

  it "should find translation by normalized keys" do
    translation = Translation.create(@valid_attributes.merge(:key => "Key", :scope => "Scope.With.Dots"))
    Translation.find_by_string_normalized_key("Scope.With.Dots.Key").should == translation
  end

  it "should find using find_by_string_normalized_key using simple key as attribute" do
    translation = Translation.create(@valid_attributes.merge(:key => "SimpleKey", :scope => nil ))
    Translation.find_by_string_normalized_key(translation.key).should == translation
  end

  it "should return array of all locale values form db" do
    Translation.create!(:key => "key", :locale => "pl")
    Translation.create!(:key => "key", :locale => "en")
    Translation.create!(:key => "key", :locale => "nl")
    Translation.locales.should == ["en", "nl", "pl"]
  end

  it "should return array of all locale values form db even some was adding later" do
    Translation.create!(:key => "key", :locale => "en")
    Translation.create!(:key => "key", :locale => "nl")
    Translation.create!(:key => "key", :locale => "pl")
    Translation.locales.should == ["en", "nl", "pl"]
    Translation.create!(:key => "key", :locale => "uk")
    Translation.locales.should == ["en", "nl", "pl", "uk"]
    # I add this test to show that we can get info about new added locales if there
    # are some locales before.
  end

  it "should return correct plural form (using count argument)" do
    Translation.create!(:key => "with_count", :translation => "translation", :zero => "none", :one => "one", :many => "many ({{count}})")
    I18n.t("with_count", :count => 0).should == "none"
    I18n.t("with_count", :count => 1).should == "one"
    I18n.t("with_count", :count => 2).should == "many (2)"
  end

end
