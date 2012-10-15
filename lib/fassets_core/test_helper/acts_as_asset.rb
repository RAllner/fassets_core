require "rspec"

shared_examples_for "ActsAsAsset" do
  before(:each) do
    begin
      @the_asset = Asset.create!(:name => "Test Asset", :content => asset)
    rescue NameError
      raise "May be you need to define an asset! Use \"let(:asset){ #your code here }\" in your specs."
    end
  end

  context "associations for the model" do
    it "should have an asset object" do
      asset.asset.should == @the_asset
    end

    it "should destroy the asset model when deleted" do
      asset.destroy
      begin
        @the_asset.reload
        raise "RecordNotFound exception should have been raised!"
      rescue ActiveRecord::RecordNotFound
      end
    end

    it "should be possible to set the name for an asset through the object itself" do
      asset.asset.name="New name"
      asset.save!
      @the_asset.reload.name.should == "New name"
    end
  end

  context "instance methods for the model" do
    it "should provide a name method" do
      asset.name.should == "Test Asset"
    end

    it "should provide a media type" do
      asset.media_type.should_not be_nil
    end

    it "should provide an icon" do
      asset.icon.should_not be_nil
    end
  end
end
