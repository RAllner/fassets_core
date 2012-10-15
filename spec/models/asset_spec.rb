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

  context "association with a user" do
    let(:user) do
      begin
        return User.find 1
      rescue ActiveRecord::RecordNotFound
        User.create!(:email => "test@example.com", :password => "test123", :password_confirmation => "test123")
      end
    end
    it "should not fail without a user assigned" do
      a = Asset.create(:content => Url.create!(:url => "http://example.com"), :name => "Testname")
      a.save!
    end

    it "should be possible to assign a user" do
      a = Asset.create(:content => Url.create!(:url => "http://example.com"), :name => "Testname")
      a.user = user
      a.save!
    end

    context "when using the tray" do
      it "should be added to users tray during creation" do
        a = Asset.create!(:content => Url.create!(:url => "http://example.com"), :name => "Testname", :user => user)
        user.tray_positions.last.asset.should == a
      end

      it "should remove asset from tray on assets destruction" do
        a = Asset.create!(:content => Url.create!(:url => "http://example.com"), :name => "Testname", :user => user)
        user.tray_positions.last.asset.should  == a
        a.destroy
        user.tray_positions.should be_empty
      end

      it "should append new assets at the end" do
        a1 = Asset.create!(:content => Url.create!(:url => "http://example.com"), :name => "Testname1", :user => user)
        a2 = Asset.create!(:content => Url.create!(:url => "http://example.com"), :name => "Testname2", :user => user)
        user.tray_positions.map{ |tp| tp.asset }.should == [a1, a2]
      end
    end
  end

  context "with label filters" do
    fixtures :labels, :catalogs
    let(:catalog) { Catalog.all.first }
    let(:label1) { Label.find 1 }
    let(:label2) { Label.find 2 }

    it "should work with an empty filter" do
      f = LabelFilter.new ""
      Asset.filter(f).should == Asset.all
    end

    it "should find all assets for selected label" do
      a1 = Asset.create!(:content => Url.create!(:url => "http://example.com"), :name => "TestLabel1")
      a1_1 = Asset.create!(:content => Url.create!(:url => "http://example.com"), :name => "TestLabel1.2")
      a2 = Asset.create!(:content => Url.create!(:url => "http://example.com"), :name => "TestLabel2")
      a2_1 = Asset.create!(:content => Url.create!(:url => "http://example.com"), :name => "TestLabel2.1")
      a3 = Asset.create!(:content => Url.create!(:url => "http://example.com"), :name => "TestLabel3")

      c1 = Classification.create!(:asset => a1, :catalog => catalog)
      c1_1 = Classification.create!(:asset => a1_1, :catalog => catalog)
      c2 = Classification.create!(:asset => a2, :catalog => catalog)
      c2_1 = Classification.create!(:asset => a2_1, :catalog => catalog)
      c3 = Classification.create!(:asset => a3, :catalog => catalog)

      Labeling.create!(:classification => c1, :label => label1)
      Labeling.create!(:classification => c1_1, :label => label1)
      Labeling.create!(:classification => c2, :label => label2)
      Labeling.create!(:classification => c2_1, :label => label2)
      Labeling.create!(:classification => c3, :label => label2)
      Labeling.create!(:classification => c3, :label => label1)

      f1 = LabelFilter.new label1.id.to_s
      f2 = LabelFilter.new label2.id.to_s
      f3 = LabelFilter.new (f1 + f2).join("-")
      catalog.assets.filter(f1).should == [a1, a1_1, a3]
      catalog.assets.filter(f2).should == [a2, a2_1, a3]
      catalog.assets.filter(f3).should == [a3]
    end
  end
end
