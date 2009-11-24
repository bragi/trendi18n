require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

I18n.backend = Trendi18n::Backend::Trendi18n.new



describe Trendi18n::Backend::Trendi18n do

  before do
    I18n.backend.is_a?(Trendi18n::Backend::Trendi18n)
    @data = [{
      :key => "key1", :translation => "Translation of key1"
    }, {
      :key => "key2", :scope => "scope1.subscope1", :translation => "Translation of key2"
    }, {
      :key => "key3", :scope => "scope1.subscope2", :translation => "Translation of key 2"
    }]
    for attributes in @data do
      Translation.create!(attributes)
    end
  end


  describe "caching" do
    before(:each) do
      I18n.reload!
    end

    it "should lookup the key in db when the firts time it is used" do
      translation = Translation.new(:key => "test_key", :translation => "test_translations")
      Translation.should_receive(:lookup).once.and_return(translation)
      I18n.t("test_key")
    end

  end

end
