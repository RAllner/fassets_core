class LabelsController < FassetsCore::ApplicationController
  before_filter :authenticate_user!
  before_filter :find_label, :except => [:create, :sort]
  respond_to :html, :json
  def create
    @label = Label.new(params[:label])
    @label.facet_id = params[:facet_id]
    if @label.save
      flash[:notice] = "Label was successfully created."
      redirect_to edit_catalog_facet_path(params[:catalog_id], params[:facet_id])
    else
      if params[:label][:caption].blank?
        flash[:error] = "Label could not be created! Caption cannot be empty!"
      else
        flash[:error] = "Label could not be created!"
      end
      redirect_to :back
    end
  end
  def update
    @label.update_attributes(params[:label])
    respond_to do |format|
      if @label.save
        format.html do
          flash[:notice] = "Label was successfully updated."
          redirect_to edit_catalog_facet_path(params[:catalog_id], params[:facet_id])
        end
        format.json { respond_with_bip(@label) }
      else
        format.html do
          flash[:error] = "Label could not be updated! Caption cannot be empty!"
          redirect_to :back
        end
        format.json { respond_with_bip(@label) }
      end
    end
  end
  def sort
    params[:label].each_with_index do |id, position|
      Label.update(id, :position => position+1)
    end
    respond_to do |format|
      format.js {render :nothing  => true}
    end
  end
  def destroy
    @label.destroy
    @facet = @label.facet
    @catalog = @facet.catalog
    @label = nil

    flash[:notice] = "Label removed."
    respond_to do |format|
      format.js { }
      format.html { redirect_to :back }
    end
  end
  protected
  def find_label
    @label = Label.find(params[:id])
  end
end

