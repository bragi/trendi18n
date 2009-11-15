require 'spec_helper'

describe Translation do
  before(:each) do
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

    @status_test_attributes = [
      {:locale => "en",
        :key => "status_test1",
        :default => "default1"
      },
      {:locale => "en",
       :key => "status_test2",
       :translation => "translation2"
      },
      {:key => "status_test3 {{count}}",
       :translation => "translation3",
       :one => "one_translation3"
      },
      { :key => "status_test4 {{count}}",
        :translation => "translation4",
        :one => "one_translation4",
        :zero => "zero_translation4",
        :many => "many_translation4"
      }
    ]

    @status_test_results = ["new", "finished", "unfinished", "finished"]
  end

  it "should create a new instance given valid attributes" do
    Translation.create!(@valid_attributes)
  end

  it "should assign status to new created model" do
    for data in @status_test_attributes do
      model = Translation.new(data)
      model.save!
      model.status.should == @status_test_results[@status_test_attributes.index(data)]
    end
  end

  it "should lookup for new translations" do
    translation_new = Translation.lookup("en", "key", nil, "scope")
    translation_new.default.should == "key"
    translation_exists = Translation.lookup("en", "key", nil, "scope")
    translation_exists.should == translation_new
  end

end
