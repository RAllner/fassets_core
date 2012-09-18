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

  describe "GET new" do
    it "should have no registered plugins" do
      get 'new'
      assigns(:content).should be_nil
      assigns(:asset_types).should == []
      assigns(:selected_type).should == nil
      response.should be_success
    end

    context "HTML request" do
      it "should render assets/new template" do
        get 'new'
        response.should render_template "assets/new"
      end
    end

    context "JS request" do
      it "should render assets/new template" do
        get 'new', :format => :js
        response.should be_success
        response.should render_template "assets/new"
      end
    end

    context "with a few plugins registered" do
      before(:each) do
        FassetsCore::Plugins.stub!(:all) { [{:name => "Test1", :class => Url}, {:name => "Test2", :class => String}] }
      end

      it "should have 2 registered plugins" do
        get 'new'
        assigns(:asset_types) == [{:name => "Test1", :class => Url}, {:name => "Test2", :class => String}]
      end

      it "should select the first entry as default content" do
        get 'new'
        assigns(:content).class.should == Url
        assigns(:selected_type).should == "Test1"
        FassetsCore::Plugins.stub!(:all) { [{:name => "Test2", :class => String}, {:name => "Test1", :class => Url}] }
        get 'new'
        assigns(:content).class.should == String
        assigns(:selected_type).should == "Test2"
      end

      it "should select entry selected by type parameter" do
        get 'new', :type => "Test1"
        assigns(:content).class.should == Url
        assigns(:selected_type).should == "Test1"
        get 'new', :type => "Test2"
        assigns(:content).class.should == String
        assigns(:selected_type).should == "Test2"
      end

      it "should fail when type is not registered" do
        get 'new', :type => "Test3"
        assigns(:content).should be_nil
        assigns(:selected_type).should be_nil
      end
    end
  end
end
