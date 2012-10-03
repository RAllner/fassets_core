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

  describe "GET edit" do
    let(:test_asset) do
      a = Url.new(:url => "http://example.com/")
      a.build_asset(:name => "Test URL")
      a.save!
      a
    end

    it "should assign content" do
      a = test_asset
      get 'edit', :asset_id => a.id
      assigns(:content).should == a
    end

    it "should render edit template with layout" do
      a = test_asset
      get 'edit', :asset_id => a.id
      response.should render_template "assets/edit"
      response.should render_template "layouts/fassets_core/application"
    end

    it "should render without layout" do
      a = test_asset
      get 'edit', :asset_id => a.id, :content_only => :true
      response.should render_template "assets/edit"
      response.should_not render_template "layouts/fassets_core/application"
    end

    it "should flash error when asset not found" do
      get 'edit', :asset_id => 1
      response.should redirect_to(root_path)
      request.flash[:error].should =~ /^Couldn't find/
    end
  end

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
        response.should be_success
        response.should render_template "assets/new"
        response.should render_template "layouts/fassets_core/application"
      end

      it "should render without layout on demand" do
        get 'new', {:content_only => true}
        response.should be_success
        response.should render_template "assets/new"
        response.should_not render_template "layouts/fassets_core/application"
      end
    end

    context "JS request" do
      it "should render assets/new template" do
        get 'new', :format => :js
        response.should_not be_success
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
