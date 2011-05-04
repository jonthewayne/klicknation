class ItemsController < ApplicationController
  load_and_authorize_resource  
  helper_method :sort_column, :sort_direction

  # GET /shc/items
  # GET /shc/items.xml
  def index
    get_items
  end
  
  # GET /shc/items/pending
  # GET /shc/items/pending.xml
  def pending
    #get_pending_items
    redirect_to items_url
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
    set_new_view_defaults
    
    set_claimants
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # GET /shc/items/1/edit
  def edit
    set_claimants
  end

  # POST /shc/items
  # POST /shc/items.xml
  def create        
    respond_to do |format|
      # certain type values can only be used by admins
      if @item.save # ((%w[0 1 2 3 4].include? @item.type.to_s) ? (can? :manage, @item) : true) && @item.save
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
      # certain type values can only be used by admins      
      if @item.update_attributes(params[:item]) #((%w[0 1 2 3 4].include? @item.type.to_s) ? (can? :manage, @item) : true) && @item.update_attributes(params[:item])
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
    respond_to do |format|
      if @item.destroy
        format.html { redirect_to(items_url, :notice => 'Item was successfully deleted.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end   
  end

  private
  
  # set defaults for new action view
  def set_defaults_from_params
    # use ||= so that if new or edit reloaded after validation error, nothing is overwritten
    @item.type ||= (can? :manage, @item) ? (params[:t] ? params[:t] : 0) : 20 # one of 0,1,2,3,4,20,21,21 will usually be passed in. If not, use 0 for admins and 20 for contributors.
    @item.klass ||= params[:c] ? params[:c] : 1 # for merit abilities 0,1,2,3 will usually be passed in, otherwise we'll set it to 1
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
      @items = @items.all_merit_abilities
    else
      @items = Item.all_merit_abilities
    end
  end
  def get_pending_items
    # when called from destroy method, @items isn't created by cancan method, so create it.
    # grabbing pending merit abilities
    if @items    
      @items = @items.pending_merit_abilities
    else
      @items = Item.pending_merit_abilities
    end
  end  
  def set_claimants 
    @ability_manager = @item.ability_manager ? @item.ability_manager.admin_tool_user_id : 0
    @animation_manager = @item.animation_manager ? @item.animation_manager.admin_tool_user_id : 0
  end
end

