require 'rspec' # needed for rcov

shared_examples_for "Every AssetsController" do
  include_examples "every authenticated controller"

  describe "GET 'new'" do
    it "should assign content" do
      get 'new', additional_request_params
      assigns(:content).class.should == @controller.content_model
    end

    it "should not assign all asset types" do
      get 'new', additional_request_params
      assigns(:asset_types).should be_nil
    end

    it "should not assign selected_type" do
      get 'new', additional_request_params
      assigns(:selected_type).should be_nil
    end

    context "HTML request" do
      it "should be successful and render all partials" do
        get 'new', additional_request_params
        response.should be_success
        response.should render_template("assets/new")
      end
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
      context "HTML request" do
        it "should delete the asset and show a notice" do
          delete "destroy", additional_request_params.merge({ :id => asset.id })
          assigns(:content).should respond_to(:destroy).with(0).arguments
          response.should redirect_to root_path
          request.flash[:notice].should =~ /^Asset has been deleted!$/
        end
      end

      context "JS request" do
        it "should delete the asset" do
          delete "destroy", additional_request_params.merge({ :id => asset.id, :format => :js })
          assigns(:content).should respond_to(:destroy).with(0).arguments
          response.should be_success
          response.body.strip.should be_empty
          request.flash.should be_empty
        end
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
        controller.instance_eval { @content.stub!(:save) { false } }
        post 'update', additional_request_params.merge({ :id => asset.id, :asset => { :name => "" } })
        assigns(:content).should respond_to(:update_attributes).with(1).argument
        request.flash[:error].should =~ /^Could not update asset!$/
        response.should render_template 'assets/edit'
      end

      context "JS request" do
        it "should fail with empty name for asset" do
          controller.instance_eval do
            @content.stub!(:save) { false }
            @content.stub!(:errors) { Asset.create(:content_type => "Test").errors }
          end
          post 'update', additional_request_params.merge({ :id => asset.id, :format => :js, :asset => { :name => "" } })
          response.status.should == 422
          json = JSON.parse(response.body)
          #HACK: in fact this should be 'asset.name'
          #but errors needed to be stubbed and I’m not sure how exactly I can do this
          json["errors"].should have_key("name")
          json["errors"]["name"].first.should == "can't be blank"
        end

      end
    end
  end

  context "actions without assets" do
    it "should redirect to root with error message on error" do
      get 'show', additional_request_params.merge({ :id => asset.id })
      response.should redirect_to(root_path)
      request.flash[:error].should =~ /^Couldn't find/
    end

    it "should delete the asset and show a notice" do
      delete "destroy", additional_request_params.merge({ :id => asset.id })
      response.should redirect_to(root_path)
      request.flash[:error].should =~ /^Couldn't find/
    end

    describe "create asset" do
      after(:each) do
        assigns(:content).should_not be_nil
        assigns(:content).asset.name.should eq("Test")
      end

      let(:meta_data) do
        {"asset" => {"name" => "Test"},
         "classification" => {}}
      end

      context "HTML request" do
        it "should create a new asset" do
          p = meta_data.merge(create_params)
          controller.current_user.stub!(:tray_positions) { double(TrayPosition, :maximum => nil) }
          post 'create', additional_request_params.merge(p)
          content = assigns(:content)
          content.errors.messages.should == {}
          request.flash[:notice].should =~ /^Created new asset!$/
          response.should redirect_to controller.url_for(content) + "/edit"
        end

        it "should fail when asset cannot be saved" do
          p = meta_data
          post 'create', additional_request_params.merge(p)
          response.should render_template 'assets/new'
        end
      end

      context "JS request" do
        it "should create a new asset" do
          p = meta_data.merge(create_params).merge({:format => :js})
          post 'create', additional_request_params.merge(p)
          content = assigns(:content)
          content.errors.messages.should == {}
          response.should be_success
          response.body.strip.should be_empty
        end

        it "should fail when asset cannot be saved" do
          p = meta_data
          post 'create', additional_request_params.merge(p).merge({:format => :js})
          JSON.parse(response.body)["errors"].should_not be_nil
          response.status.should == 422
        end
      end
    end
  end
end

module FassetsCore::TestHelpers
  def setup_content
    my_a = asset
    my_a.stub!(:destroy)
    my_a.stub!(:update_attributes) { true }
    my_a.stub!(:save) { true }
    my_a.stub!(:asset) { double(Asset, :update_attributes => true, :name => "Example Asset") }
    controller.stub!(:find_content) { }
    controller.instance_eval { @content = my_a }
  end

  def root_path
    "/"
  end

  def additional_request_params
    {}
  end
end

RSpec.configure do |config|
  config.include FassetsCore::TestHelpers, :type => :controller
end