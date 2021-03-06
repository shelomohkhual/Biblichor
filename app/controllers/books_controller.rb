class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show]

  def search  
    if params[:search].blank?  
      redirect_to(root_path, alert: "Empty field!") and return  
    elsif Book.all.empty?
      redirect_to(root_path, alert: "Empty DB!") and return  
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
    # @books = Book.all.order('created_at DESC')
    @genres = Genre.all
    @genre = if params[:genre]
      params[:genre]
    else
      nil
    end
    @books = if params[:genre]
      Book.genre(params[:genre])
    else
      Book.all.order('created_at DESC')
    end
  end

  # GET /books/1
  # GET /books/1.json
  def show
    # if user_signed_in?
    #   @review = Review.new
    # end
    @books = Book.all.order('created_at DESC')
    @book= Book.find_by(id: params[:id])
    @user = current_user
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
    @book = Book.new(book_params.merge(user_id:current_user.id))
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
     
    # genre = []
    # genre_ids = book_params[:genre_ids]
    # genre_ids.size.times do |n|
    #   if book_params[:genre_ids][n].to_i == 0
    #     nil
    #   else
    #     genre << Genre.find_by(id: book_params[:genre_ids][n].to_i)
    #   end
    # end
    

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
    # @book_genre = BookGenre.find_by(book_id: @book.id)
    # @book_genre.destroy
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
      params.require(:book).permit(:title,
                                  :author,
                                  :published_date,
                                  :description,
                                  :front_cover,
                                  :back_cover,
                                  :features,
                                  :price,
                                  genre_ids: [])
    end
   
    

end
