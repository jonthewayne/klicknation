class PiecesController < ApplicationController
  helper_method :sort_column, :sort_direction
  
  # GET /pieces
  # GET /pieces.xml
  def index
    get_pieces
  end

  # GET /pieces/1
  # GET /pieces/1.xml
  def show
    @piece = Piece.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @piece }
    end
  end

  # GET /pieces/new
  # GET /pieces/new.xml
  def new
    @piece = Piece.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @piece }
    end
  end

  # GET /pieces/1/edit
  def edit
    @piece = Piece.find(params[:id])
  end

  # POST /pieces
  # POST /pieces.xml
  def create
    @piece = Piece.new(params[:piece])

    respond_to do |format|
      if @piece.save
        format.html { redirect_to(pieces_url, :notice => 'Game Piece was successfully created.') }
        format.xml  { render :xml => @piece, :status => :created, :location => @piece }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @piece.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pieces/1
  # PUT /pieces/1.xml
  def update
    @piece = Piece.find(params[:id])

    respond_to do |format|
      if @piece.update_attributes(params[:piece])
        format.html { redirect_to(pieces_url, :notice => "Game Piece was successfully updated.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @piece.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pieces/1
  # DELETE /pieces/1.xml
  def destroy
    @piece = Piece.find(params[:id])
    @piece.destroy

    get_pieces
    
    render 'pieces/index'    
  end

  private
  
  def sort_column
    Piece.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
  def get_pieces
    @pieces = Piece.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 2, :page => params[:page])    
    
    if @pieces.empty? && (params[:page].to_i > 1)
      # if @pieces is empty and we're specifying greater than page 1, in most cases we need the page just before
      params[:page] = (params[:page].to_i - 1)
      @pieces = Piece.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 2, :page => params[:page])        
      # if @pieces is still empty, we should just do the query to get the last available page
      if @pieces.empty?      
        params[:page] = @pieces.total_pages
        @pieces = Piece.search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 2, :page => params[:page])            
      end
    end    
  end
end

