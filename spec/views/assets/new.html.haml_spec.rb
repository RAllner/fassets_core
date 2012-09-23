require 'spec_helper'

describe "assets/new.html.haml" do
  context "asset types without namespace" do
    let(:url) do
      url = mock_model(Url, :model_name => "Url")
      url
    end
    before(:each) do
      assign(:content, url)
      render
    end

    it "should render asset name field" do
      rendered.should have_css("form input#asset_name")
    end

    it "should render catalog selector" do
      rendered.should have_css("form select#classification_catalog_id")
    end

    it "should render form fields for the model" do
      rendered.should have_css("form input#url_url")
    end
  end
end

