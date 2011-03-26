class AdminToolUsersController < ApplicationController
  load_and_authorize_resource
  helper_method :sort_column, :sort_direction
  
  # GET /users
  # GET /users.xml
  def index
    get_users  
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    redirect_to(edit_admin_tool_user_url(@admin_tool_user))
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @admin_tool_user }
    end
  end

  # GET /users/1/edit
  def edit
    # Redirect everyone to referer so that when people click on the My Account button they are
    # redirected back to where they came from.   
    session['return-to'] ||= request.referer
  end

  # POST /users
  # POST /users.xml
  def create
    # protect roles    
    @admin_tool_user.roles = params[:admin_tool_user][:roles] if params[:admin_tool_user][:roles] && is_super?
    respond_to do |format|
      if @admin_tool_user.save
        format.html { redirect_to(admin_tool_users_path, :notice => 'Admin User was successfully created.') }
        format.xml  { render :xml => @admin_tool_user, :status => :created, :location => @admin_tool_user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @admin_tool_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    # protect roles
    @admin_tool_user.roles = params[:admin_tool_user][:roles] if params[:admin_tool_user][:roles] && is_super?
    
    respond_to do |format|
      if @admin_tool_user.update_attributes(params[:admin_tool_user])
        # set session['return-to'] to nil so user can go back to edit their account and this session var will get reset as it should
        previous_location = session['return-to']
        session['return-to'] = nil
        format.html { redirect_to(previous_location, :notice => "Admin User was successfully updated.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @admin_tool_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @admin_tool_user.destroy

    get_users
    
    render 'admin_tool_users/index'    
  end

  private
  
  def sort_column
    AdminToolUser.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
  
  def users_search
    # when called from destroy method, @admin_tool_users isn't created by cancan method, so create it.
    if @admin_tool_users
      @admin_tool_users = @admin_tool_users.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page => params[:page])          
    else
      @admin_tool_users = AdminToolUser.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 5, :page => params[:page])          
    end
  end
  
  def get_users
    users_search
    
    if @admin_tool_users.empty? && (params[:page].to_i > 1)
      # if @admin_tool_users is empty and we're specifying greater than page 1, in most cases we need the page just before
      params[:page] = (params[:page].to_i - 1)
      users_search
      # if @admin_tool_users is still empty, we should just do the query to get the last available page
      if @admin_tool_users.empty?      
        params[:page] = @admin_tool_users.total_pages
        users_search
      end
    end    
  end
end

