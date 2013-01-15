class AssetsController < FassetsCore::ApplicationController
  include AssetsHelper
  before_filter :authenticate_user!, :except => [:show]
  before_filter :find_content, :except => [:new, :create, :classifications]
  respond_to :html, :js
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
      format.js { render :template => 'assets/new', :layout => !(params["content_only"]) }
      #format.html { render :template => 'assets/new', :layout => !(params["content_only"]) }
    end
  end
  def create
    @content = self.content_model.new(content_params)
    @content.asset = Asset.create(:user => current_user, :name => params["asset"]["name"])
    respond_to do |format|
      if @content.save
        @classification = Classification.new(:catalog_id => params["classification"]["catalog_id"],:asset_id => @content.asset.id)
        @classification.save
        flash[:notice] = "Created new asset!"
        format.js { render :nothing => true }
        format.html { redirect_to edit_asset_content_path(@content) }
      else
        flash[:error] = "Could not create asset!"
        format.js { render :json => {:errors => @content.errors.messages}.to_json, :status => :unprocessable_entity }
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
    render :template => 'assets/edit', :layout => !(params["content_only"])
  end
  def update
    @content.update_attributes(content_params)
    @content.asset.update_attributes(params["asset"])
    if @content.save
      flash[:notice] = "Succesfully updated asset!"
      render :nothing => true
    else
      respond_to do |format|
        format.js { render :json => {:errors => @content.errors.messages}.to_json, :status => :unprocessable_entity }
        format.html do
          flash[:error] = "Could not update asset!"
          render :template => 'assets/edit'
        end
      end
    end
  end
  def destroy
    @content.destroy
    respond_to do |format|
      format.js { render :nothing => true }
      format.html do
        flash[:notice] = "Asset has been deleted!"
        redirect_to main_app.root_url
      end
    end
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
    if self.respond_to?(:content_model)
      @content = content_model.find(params[:id])
    elsif !params[:asset_id].nil?
      asset = Asset.find(params[:asset_id])
      @content = asset.content
    end
  rescue ActiveRecord::RecordNotFound => e
    flash[:error] = e.message
    redirect_to main_app.root_url
  end
end
