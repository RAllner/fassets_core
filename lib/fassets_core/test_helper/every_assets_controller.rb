require 'rspec' # needed for rcov

shared_examples_for "Every AssetsController" do
  include_examples "every authenticated controller"

  describe "GET 'new'" do
    it "should be successful and render all partials" do
      get 'new', additional_request_params
      response.should be_success
      response.should render_template("assets/new")
    end
  end

  context "actions with assets" do
    before(:each) do
      setup_content
    end

    it "should render the edit template" do
      get 'edit', additional_request_params.merge({ :id => asset.id })
      response.should be_success
      response.should render_template("assets/edit")
    end

    describe "GET 'show'" do
      it "should assign content" do
        get 'show', additional_request_params.merge({ :id => asset.id })
        assigns(:content).should_not be_nil
      end
    end

    describe "DELETE asset" do
      it "should delete the asset and show a notice" do
        delete "destroy", additional_request_params.merge({ :id => asset.id })
        assigns(:content).should respond_to(:destroy).with(0).arguments
        response.should redirect_to root_path
        request.flash[:notice].should =~ /^Asset has been deleted!$/
      end
    end

    describe "update asset" do
      it "should show a 'successful' message on success" do
        controller.stub!(:url_for) { "/asset" }
        post 'update', additional_request_params.merge({ :id => asset.id })
        assigns(:content).should_not be_nil
        assigns(:content).should respond_to(:update_attributes).with(1).argument
        request.flash[:notice].should =~ /^Succesfully updated asset!$/
        response.should be_success
      end

      it "should throw an error when update fails" do
        controller.instance_eval { @content.stub!(:update_attributes) { false } }
        post 'update', additional_request_params.merge({ :id => asset.id })
        assigns(:content).should respond_to(:update_attributes).with(1).argument
        request.flash[:error].should =~ /^Could not update asset!$/
        response.should render_template 'assets/edit'
      end
    end
  end

  context "actions without assets" do
    it "should redirect to root with error message on error" do
      get 'show', additional_request_params.merge({ :id => asset.id })
      response.should redirect_to(root_path)
      request.flash[:error].should =~ /not found$/
    end

    it "should delete the asset and show a notice" do
      delete "destroy", additional_request_params.merge({ :id => asset.id })
      response.should redirect_to(root_path)
      request.flash[:error].should =~ /not found$/
    end

    describe "create asset" do
      after(:each) do
        assigns(:content).should_not be_nil
        assigns(:content).asset.name.should eq("Test")
      end

      it "should create a new asset" do
        controller.stub!(:params) do
          {"asset" => {"name" => "Test"},
           "classification" => {}
           }.merge(create_params)
        end
        controller.current_user.stub!(:tray_positions) { double(TrayPosition, :maximum => nil) }
        get 'create', additional_request_params
        content = assigns(:content)
        content.errors.messages.should == {}
        request.flash[:notice].should =~ /^Created new asset!$/
        response.should redirect_to controller.url_for(content) + "/edit"
      end

      it "should fail when asset cannot be saved" do
        controller.stub!(:params) do
          {"asset" => {"name" => "Test"}}
        end
        get 'create', additional_request_params
        response.should render_template 'assets/new'
      end
    end
  end
end

module FassetsCore::TestHelpers
  def setup_content
    my_a = asset
    my_a.stub!(:destroy)
    my_a.stub!(:update_attributes) { true }
    my_a.stub!(:asset) { double(Asset, :update_attributes => true) }
    controller.stub!(:find_content) {}
    controller.instance_eval { @content = my_a }
  end

  def additional_request_params
    {}
  end
end

RSpec.configure do |config|
  config.include FassetsCore::TestHelpers, :type => :controller
end