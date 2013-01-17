class FacetsController < FassetsCore::ApplicationController
  before_filter :authenticate_user!
  before_filter :find_catalog

  def new
    respond_to do |format|
      format.js 
      format.html 
    end
  end
  def create
    @facet = Facet.new(params[:facet])
    @facet.catalog_id = @catalog.id
    if @facet.save
      flash[:notice] = "Facet was successfully created."
      redirect_to catalog_path(@catalog)
    else
      if params[:facet][:caption].blank?
        flash[:error] = "Facet could not be created! Caption cannot be empty!"
      else
        flash[:error] = "Facet could not be created!"
      end      
      redirect_to :back
    end
  end
  def edit
    @facet = @catalog.facets.find(params[:id])
    respond_to do |format|
      format.js 
      format.html 
    end
  end
  def update
    if params[:facet][:caption].blank?
      flash[:error] = "Facet could not be updated! Caption cannot be empty"
      redirect_to :back
      return
    end
    @facet = @catalog.facets.find(params[:id])
    if @facet.update_attributes(params[:facet])
      flash[:notice] = "Facet has been updated."
      redirect_to  catalog_path(@catalog)
    else
      render :action => 'edit'
    end
  end
  def destroy
    @catalog = @catalog.facets.find(params[:id])
    @catalog.destroy
    flash[:notice] = "Facet was successfully destroyed."
    redirect_to catalog_path(@catalog)
  end
  def sort
    @facetsInScope = Facet.where("catalog_id = ?", @catalog.id)	  
    params[:facet].each_with_index do |id, index|
      @facetsInScope.update(id, :position => index)     
    end
    render :nothing => true	  
  end	  
  protected
  def find_catalog
    @catalog = Catalog.find(params[:catalog_id])
  end
end

