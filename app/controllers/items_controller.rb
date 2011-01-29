class ItemsController < ApplicationController
  load_and_authorize_resource  
  helper_method :sort_column, :sort_direction

  # GET /items
  # GET /items.xml
  def index
    get_items
    #render :text => @items.first.to_yaml
    #return
  end

  # GET /items/1
  # GET /items/1.xml
  def show
    redirect_to(edit_item_url(@item))
  end

  # GET /items/new
  # GET /items/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # GET /items/1/edit
  def edit

  end

  # POST /items
  # POST /items.xml
  def create
    
    # set class, type based on url params
    @class = params[:class] if params[:class]
    @type = params[:type] if params[:type]
    
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

  # PUT /items/1
  # PUT /items/1.xml
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

  # DELETE /items/1
  # DELETE /items/1.xml
  def destroy
    @item.destroy

    get_items
    
    render 'items/index'    
  end

  private
  
  def sort_column
    Item.column_names.include?(params[:sort]) ? params[:sort] : "sort"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
  
  def items_search
    # when called from destroy method, @items isn't created by cancan method, so create it.
    if @items    
      @items = @items.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page => params[:page])          
    else
      @items = Item.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page => params[:page])                
    end
  end
  
  def get_items
    items_search
    
    if @items.empty? && (params[:page].to_i > 1)
      # if @items is empty and we're specifying greater than page 1, in most cases we need the page just before
      params[:page] = (params[:page].to_i - 1)
      items_search
      # if @items is still empty, we should just do the query to get the last available page
      if @items.empty?      
        params[:page] = @items.total_pages
        items_search
      end
    end    
  end
end

