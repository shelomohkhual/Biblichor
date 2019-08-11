class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def search  
    if params[:search].blank?  
      redirect_to(root_path, alert: "Empty field!") and return  
    else  
        search = params[:search].present? ? params[:search] : nil
        @search_result = if search
            Book.search(search)
        else
            nil
        end
    end
  end  

  # GET /books
  # GET /books.json
  def index
    @books = Book.all.order('created_at DESC')
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @books = Book.all.order('created_at DESC')
    @book= Book.find_by(id: params[:id])
    @owner = User.find_by(id: @book[:owner_id] )
    # byebug
    if @book[:owner_name]== nil
      @book[:owner_name] = @owner.username != nil ? @owner.username : @owner.name
    else
      nil
    end

  end

  # GET /books/new
  def new
    @book = Book.new
    @genre = Genre.all
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  # POST /books.json
  def create
    @book = Book.new(book_params)
    @book.owner_id = current_user.id
    # byebug
    @book.owner_name = current_user.username != nil ? current_user.username : current_user.name
    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      if Book.exists?(params[:id])
        @book = Book.find(params[:id])
      else
        redirect_to "/books", alert: "there's no SUCH book"
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:title, :author, :published_date, :description, :genre, :front_cover, :back_cover, :features, :price)
    end

    # def book_exist?(id)
    #   # byebug
    #   if !Book.exists?(id)
    #     # render :root_path
    #     redirect_to books_path

    #     byebug
    #   end
    # end

    

end
