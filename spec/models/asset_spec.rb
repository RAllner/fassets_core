require 'spec_helper'

describe Asset do
  it "should have content" do
    a = Asset.create
    a.errors.messages.should == { :name => ["can't be blank"], :content_type => ["can't be blank"]}
    a = Asset.create(:content => Url.create!(:url => "http://example.com"))
    a.errors.messages.should == { :name => ["can't be blank"]}
  end

  it "should have a name" do
    a = Asset.create
    a.errors.messages.should == {:name => ["can't be blank"], :content_type => ["can't be blank"]}
    a = Asset.create(:name => "Testname")
    a.errors.messages.should == {:content_type => ["can't be blank"]}
  end

  it "should not fail without a user assigned" do
    a = Asset.create(:content => Url.create!(:url => "http://example.com"), :name => "Testname")
    a.save!
  end

  context "with classifications" do
    before(:each) do
      a = Asset.create!(:content => Url.create!(:url => "http://example.com"), :name => "Testasset")
      a.classifications.should == []
      c1 = Classification.create!(:asset => a)
      c2 = Classification.create!(:asset => a)
      @asset_id = a.id
    end

    it "should have a list of associated classifications" do
      a = Asset.find @asset_id
      a.classifications.should == Classification.all
    end

    it "should destroy classifications when object is destroyed" do
      c_all = Classification.all
      a = Asset.find @asset_id
      a.destroy
      c_all.should_not == Classification.all
    end
  end
end
