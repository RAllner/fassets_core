class AssetsController < FassetsCore::ApplicationController
  include AssetsHelper
  before_filter :authenticate_user!, :except => [:show]
  before_filter :find_content, :except => [:new, :create, :classifications]

  def new
    if self.respond_to?(:content_model)
      @content = self.content_model.new
    else
      @asset_types = FassetsCore::Plugins::all
      type = @asset_types.select{ |t| t[:name] == params[:type]}.first
      type ||= @asset_types.first if params[:type].nil?
      unless type.nil?
        @selected_type = type[:name]
        @content = type[:class].new
      end
    end
    respond_to do |format|
      format.html { render :template => 'assets/new' }
      format.js { render :template => 'assets/new' }
    end
  end
  def create
    @content = self.content_model.new(content_params)
    @content.asset = Asset.create(:user => current_user, :name => params["asset"]["name"])
    respond_to do |format|
      if @content.save
        @classification = Classification.new(:catalog_id => params["classification"]["catalog_id"],:asset_id => @content.asset.id)
        @classification.save
        create_content_labeling(@content.asset.id, params["classification"]["catalog_id"])
        flash[:notice] = "Created new asset!"
        format.js { render :json => @content.to_jq_upload.merge({:status => :ok}).to_json }
        format.html { redirect_to edit_asset_content_path(@content) }
      else
        flash[:error] = "Could not create asset!"
        format.js { render :json => {:errors => @content.errors.messages}.to_json }
        format.html do
          render :template => 'assets/new'
        end
      end
    end
  end
  def show
    render :template => 'assets/show'
  end
  def edit
    render :template => 'assets/edit', :locals => {:in_fancybox => false}, :layout => false
  end
  def update
    if @content.update_attributes(content_params) and @content.asset.update_attributes(params["asset"])
      flash[:notice] = "Succesfully updated asset!"
      render :nothing => true
    else
      flash[:error] = "Could not update asset!"
      render :template => 'assets/edit'
    end
  end
  def destroy
    flash[:notice] = "Asset has been deleted!"
    @content.destroy
    redirect_to main_app.root_url
  end
  def preview
    render :partial => content_model.to_s.underscore.pluralize + "/" + @content.media_type.to_s.underscore + "_preview"
  end
  def classifications
    @content = Asset.find(params[:id]).content
    render :partial => "assets/classification"
  end
  protected
  def content_params
    field_name = self.content_model.to_s.underscore.gsub("/","_")
    logger.debug field_name
    params[field_name]
  end
  def find_content
    if params[:asset_id]
      content_id = Asset.find(params[:id]).content_id
    else
      content_id = params[:id]
    end
    content_id = Asset.find(params[:id]).content_id
    @content = self.content_model.find(content_id)
  rescue ActiveRecord::RecordNotFound => e
    flash[:error] = "#{self.content_model.to_s} with id #{params[:id]} not found"
    redirect_to main_app.root_url
  end
  def create_content_labeling(asset_id,catalog_id)
    asset = Asset.find(asset_id)
    content_facet = Facet.where(:catalog_id => catalog_id, :caption => "Content Type").first
    return if content_facet.nil?
    content_facet.labels.each do |label|
      if asset.content_type == "FileAsset"
        if label.caption.downcase == asset.content.media_type
          labeling = Labeling.new(:classification_id => @classification.id, :label_id => label.id)
          labeling.save
        end
      elsif asset.content_type == "Url"
        if label.caption == "Url"
          labeling = Labeling.new(:classification_id => @classification.id, :label_id => label.id)
          labeling.save
        end
      elsif asset.content_type == "Code"
        if label.caption == "Code"
          labeling = Labeling.new(:classification_id => @classification.id, :label_id => label.id)
          labeling.save
        end
      elsif asset.content_type == "FassetsPresentations::Presentation"
        if label.caption == "Presentation"
          labeling = Labeling.new(:classification_id => @classification.id, :label_id => label.id)
          labeling.save
        end
      end
    end
  end
end
