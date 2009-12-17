require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

I18n.backend = Trendi18n::Backend::Trendi18n.new



describe Trendi18n::Backend::Trendi18n do

  before do
    I18n.backend.is_a?(Trendi18n::Backend::Trendi18n).should == true
    @data = [{
      :key => "key1", :translation => "Translation of key1"
    }, {
      :key => "key2", :scope => "scope1.subscope1", :translation => "Translation of key2"
    }, {
      :key => "key3", :scope => "scope1.subscope2", :translation => "Translation of key3"
    }]
    for attributes in @data do
      Translation.create!(attributes)
    end
  end


  describe "caching" do
    before(:each) do
      I18n.reload!
      @translation = Translation.create(:locale => "en",:key => "test_key", :translation => "test_translations")
    end

    it "should lookup the key in db when the firts time it is used" do
      Translation.should_receive(:lookup).once.and_return(@translation)
      I18n.t("test_key")
    end

    it "should use cache when the key is used more then one time" do
      Translation.should_receive(:lookup).once.and_return(@translation)
      2.times { I18n.t("test_key")}
    end

    it "should clear cache after backend reload" do
      Translation.should_receive(:lookup).twice.and_return(@translation)
      I18n.t("test_key")
      I18n.reload!
      I18n.t("test_key")
    end
  end

  describe "standard i18n functionality" do

    it "should find translation without scopes" do
      I18n.t(:key1).should == "Translation of key1"
    end

    describe "if there is no translation" do

      it "should return a default string value" do
        I18n.t(:non_existing_key, :default => "This key not exists").should == "This key not exists"
      end

      it "should return default translation given as symbol"

      it "should return default translation from string in array"

      it "should return default translation from symbol in array"

    end

    describe "while looking for translations with scopes" do

      it "should look up translation with scope (as a string) in options" do
        I18n.t(:key2, :scope => "scope1.subscope1").should == "Translation of key2"
      end

      it "should look up translation with scope (as a array of symbols) in options" do
        I18n.t(:key2, :scope => [:scope1, :subscope1]).should == "Translation of key2"
      end

      it "should look up translation with scope (as a symbol) in options" do
        I18n.t(:key2, :scope => "scope1.subscope1".to_sym).should == "Translation of key2"
      end

      it "should look up translation with scope info in key (as a string)" do
        I18n.t("scope1.subscope1.key2").should == "Translation of key2"
      end

      it "should look up translation with scope info in key (as a symbol)" do
        I18n.t("scope1.subscope1.key2".to_sym).should == "Translation of key2"
      end

      it "should look up translation with scope info in key and scope options" do
        I18n.t("subscope1.key2".to_sym, :scope => "scope1").should == "Translation of key2"
      end

    end

    describe "multi-translations" do

      it "should look up many translations at once" do
        I18n.t([:key1, "scope1.subscope1.key2"]).should == ["Translation of key1", "Translation of key2"]
      end

      it "should look up many translations at once, with scope option" do
        I18n.t(["subscope1.key2", "subscope2.key3"], :scope => :scope1).should == ["Translation of key2", "Translation of key3"]
      end

    end

    describe "while scope given as a key" do

      it "should translate to hash of translations"

    end


  end

end
