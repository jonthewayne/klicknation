class ItemsController < ApplicationController
  load_and_authorize_resource  
  helper_method :sort_column, :sort_direction

  # GET /shc/items
  # GET /shc/items.xml
  def index
    get_items
  end

  # GET /shc/items/1
  # GET /shc/items/1.xml
  def show
    redirect_to(edit_item_url(@item))
  end

  # GET /shc/items/new
  # GET /shc/items/new.xml
  def new
    set_defaults_from_params
    @item.set_defaults
    set_new_view_defaults
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # GET /shc/items/1/edit
  def edit

  end

  # POST /shc/items
  # POST /shc/items.xml
  def create    
    respond_to do |format|
      if @item.save
        format.html { redirect_to(edit_item_url(@item), :notice => 'Item was successfully created.') }
        format.xml  { render :xml => @item, :status => :created, :location => @item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /shc/items/1
  # PUT /shc/items/1.xml
  def update
    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to(edit_item_url(@item), :notice => 'Item was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /shc/items/1
  # DELETE /shc/items/1.xml
  def destroy
    @item.destroy
    get_items  
    render 'items/index'    
  end

  private
  
  # set defaults for new action view
  def set_defaults_from_params
    # use ||= so that if new or edit reloaded after validation error, nothing is overwritten
    @item.type ||= params[:t] ? params[:t] : 0 # one of 0,1,2,3,4 should aways be passed in
    @item.klass ||= params[:c] ? params[:c] : 0 # for merit abilities 1,2,3 will be passed in, otherwise it's special
    @item.currency_type ||= params[:ct] # defaults to "1" from mysql
  end
  
  def set_new_view_defaults
    # the db gives some fields a default value, but we don't want those in the new view
    @item.attack = nil
    @item.defense = nil
    @item.agility = nil    
  end
  
  def sort_column
    Item.column_names.include?(params[:sort]) ? params[:sort] : "sort"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
  
  def get_items
    # when called from destroy method, @items isn't created by cancan method, so create it.
    # grabbing merit abilities
    if @items    
      @items = @items.where("sort > 0 AND currency_type = 1 AND num_available > 0 AND (class IN (1,2,3)) AND (type IN (0,1,2)) AND (level IN (1,40,80))").order("class, sort")
    else
      @items = Item.where("sort > 0 AND currency_type = 1 AND num_available > 0 AND (class IN (1,2,3)) AND (type IN (0,1,2))").order("class, sort")
    end
  end
end

