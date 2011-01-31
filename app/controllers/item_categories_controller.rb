class ItemCategoriesController < ApplicationController
  load_and_authorize_resource
  helper_method :sort_column, :sort_direction
  
  # GET /shc/item-categories
  # GET /shc/item-categories.xml
  def index
    get_item_categories  
  end

  # GET /shc/item-categories/1
  # GET /shc/item-categories/1.xml
  def show
    redirect_to(edit_item_category_url(@item_category))
  end

  # GET /shc/item-categories/new
  # GET /shc/item-categories/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item_category }
    end
  end

  # GET /shc/item-categories/1/edit
  def edit

  end

  # POST /shc/item-categories
  # POST /shc/item-categories.xml
  def create
    respond_to do |format|
      if @item_category.save
        format.html { redirect_to(item_categories_path, :notice => 'Item Category was successfully created.') }
        format.xml  { render :xml => @item_category, :status => :created, :location => @item_category }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @item_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /shc/item-categories/1
  # PUT /shc/item-categories/1.xml
  def update    
    respond_to do |format|
      if @item_category.update_attributes(params[:item_category])
        format.html { redirect_to(item_categories_path, :notice => "Item Category was successfully updated.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item_category.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /shc/item-categories/1
  # DELETE /shc/item-categories/1.xml
  def destroy
    @item_category.destroy

    get_item_categories
    
    render 'item_categories/index'    
  end

  private
  
  def sort_column
    ItemCategory.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
  
  def item_categories_search
    # when called from destroy method, @item_categories isn't created by cancan method, so create it.
    if @item_categories
      @item_categories = @item_categories.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 50, :page => params[:page])          
    else
      @item_categories = ItemCategory.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 50, :page => params[:page])          
    end
  end
  
  def get_item_categories
    item_categories_search
    
    if @item_categories.empty? && (params[:page].to_i > 1)
      # if @item_categories is empty and we're specifying greater than page 1, in most cases we need the page just before
      params[:page] = (params[:page].to_i - 1)
      item_categories_search
      # if @item_categories is still empty, we should just do the query to get the last available page
      if @item_categories.empty?      
        params[:page] = @item_categories.total_pages
        item_categories_search
      end
    end    
  end
end

