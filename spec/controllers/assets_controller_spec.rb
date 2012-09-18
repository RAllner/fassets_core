require 'spec_helper'

describe UrlsController do
  # this is a controller implemented within the dummy application and used for testing the
  # "Every AssetsController" shared example

  # Define an example asset that this controller should create
  let(:asset) { double(Url, :id => 1, :url => "http://example.com/") }

  # Define parameters that are send to the create action of the controller
  # These are only the parameters specific to the object itself, no meta-data
  # like asset.name or classifications is needed, here
  let(:create_params) do
    {"url" => {:url => "http://example.com/"}}
  end

  # include the shared examples provided by fassets_core TestHelper
  include_examples "every authenticated controller"
  it_should_behave_like "Every AssetsController"
end

describe AssetsController do
  include_examples "every authenticated controller"

  context "add asset box" do
    it "should have no registered plugins" do
      get 'add_asset_box'
      assigns(:content).should be_nil
      assigns(:asset_types).should == []
      response.should be_success
      response.should render_template "assets/add_asset_box"
    end

    context "with a few plugins registered" do
      before(:each) do
        FassetsCore::Plugins.stub!(:all) { [{:name => "Test1", :class => Url}, {:name => "Test2", :class => String}] }
      end

      it "should have 2 registered plugins" do
        get 'add_asset_box'
        assigns(:asset_types) == [{:name => "Test1", :class => Url}, {:name => "Test2", :class => String}]
      end

      it "should select the first entry as default content" do
        get 'add_asset_box'
        assigns(:content).class.should == Url
        FassetsCore::Plugins.stub!(:all) { [{:name => "Test2", :class => String}, {:name => "Test1", :class => Url}] }
        get 'add_asset_box'
        assigns(:content).class.should == String
      end

      it "should select entry selected by type parameter" do
        get 'add_asset_box', :type => 0
        assigns(:content).class.should == Url
        get 'add_asset_box', :type => 1
        assigns(:content).class.should == String
      end

      it "should fail when type is not registered" do
        get 'add_asset_box', :type => 2
        assigns(:content).should be_nil
      end
    end
  end
end
