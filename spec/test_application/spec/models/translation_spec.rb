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
      puts @status_test_attributes.index(data)
      model.has_some_plural_forms?.should == true if @status_test_attributes.index(data) == 2
      model.status.should == @status_test_results[@status_test_attributes.index(data)]
    end

  end
end
