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
end
