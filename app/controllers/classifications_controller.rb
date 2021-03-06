class ClassificationsController < FassetsCore::ApplicationController
  before_filter :authenticate_user!
  before_filter :find_classification, :only => [:update, :destroy]

  respond_to :html, :js

  def create
    if params[:asset_id]
      @classification = Classification.new(:asset_id => params[:asset_id],:catalog_id => params[:catalog_id])
      @classification.save
      create_content_labeling(params[:asset_id],params[:catalog_id])
    else
      classification = Classification.new(params[:classification])
      classification.save
    end
    render :nothing => true
  end
  def destroy
    @classification.destroy
    render :nothing => true
  end
  def update
    if params[:commit] == "Drop"
      @classification.destroy()
      return
    end
    @classification.label_ids = params[:labels]
    flash[:notice] = "Updated Classification"
    respond_with do |format|
      format.js
      format.html {}
    end
  end

  protected
  def create_content_labeling(asset_id,catalog_id)
    asset = Asset.find(asset_id)
    content_facet = Facet.where(:catalog_id => catalog_id, :caption => "Content Type").first
    unless content_facet
      content_facet = Facet.create(:caption => "Content Type", :color => "orange", :label_order => "value ASC, caption ASC", :catalog_id => catalog_id)
    end
    media_type = asset.content.media_type.capitalize
    label = Label.where(:facet_id => content_facet.id, :caption => media_type.to_s).first
    unless label
      label = Label.new(:facet_id => content_facet.id, :caption => media_type.to_s)
      label.save
    end
    labeling = Labeling.new(:classification_id => @classification.id, :label_id => label.id)  
    labeling.save
  end
  
  def find_classification
    @classification = Classification.find(params[:id])
  end
end

