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

  describe "locales tools" do

    it "should return array of all locale values form db" do
       Translation.create!(:key => "key", :locale => "pl")
       Translation.create!(:key => "key", :locale => "en")
       Translation.create!(:key => "key", :locale => "nl")
       Translation.set_locales
       Translation.get_locales.include?(:en).should == true
       Translation.get_locales.include?(:nl).should == true
       Translation.get_locales.include?(:pl).should == true
    end

  end

  it "should return correct plural form (using count argument)" do
    Translation.create!(:key => "with_count", :translation => "translation", :zero => "none", :one => "one", :many => "many ({{count}})")
    I18n.t("with_count", :count => 0).should == "none"
    I18n.t("with_count", :count => 1).should == "one"
    I18n.t("with_count", :count => 2).should == "many (2)"
  end

  describe "scope recognizing" do

    it "should recognize something is scope, not key" do
      Translation.create!(:key => "key", :locale => "en", :scope => "scope")
      Translation.scope?("scope", "en").should == true
    end

    it "should recognize something is key, when scope with the same name exists and key has no scope" do
      Translation.create!(:key => "scope", :locale => "en")
      Translation.create!(:key => "key", :scope => "scope", :locale => "en")
      Translation.scope?("scope", "en").should == false
    end

    it "should recognize something is scope, when key with the same name exists and has some scope" do
      Translation.create!(:key => "scope", :locale => "en", :scope => "real.scope")
      Translation.create!(:key => "key", :locale => "en", :scope => "scope")
      Translation.scope?("scope", "en").should == true
    end

    it "should recognize something is scope, when key with the same name exists, but has different locale" do
      Translation.create!(:key => "scope", :locale => "pl")
      Translation.create!(:key => "key", :scope => "scope", :locale => "en")
      Translation.scope?("scope", "pl").should == false
      Translation.scope?("scope", "en").should == true
    end

  end
end
