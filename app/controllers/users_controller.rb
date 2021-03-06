class UsersController < ApplicationController
    before_action :authenticate_user!, only: [:edit, :update, :destroy]
    
    def cart
        if user_signed_in?
            @cart= current_user.cart.reverse
        else
            @cart=[]
            # redirect_to(new_user_session_path, alert: "signed first") and return
        end
    end

    def add_cart
        if user_signed_in?
            user = current_user
            if user.cart.include?(Book.find_by(id: params[:book]))
                redirect_to(cart_path, notice: "added") and return
            else
                user.cart << Book.find_by(id: params[:book])
                if user.save
                    redirect_to cart_path
                else
                    redirect_to(cart_path, alert: "no save") and return
                end
            end
        else
            redirect_to(new_user_session_path, alert: "signed first") and return
        end
    end

    def remove_cart
        user = current_user
        if user.cart.include?(Book.find_by(id: params[:book]))
            user.cart.delete(Book.find_by(id: params[:book]))
            if user.save
                redirect_to cart_path
            else
                redirect_to(cart_path, alert: "no save") and return
            end
        else
            nil
        end
    end

    def index
        @user = current_user
        unless Book.all.empty?
            books = Book.all.order('created_at DESC')
            if books.size > 4
                @books = books[0..3]
            else
                @books = books
            end
        end
    end
    
    def show
        @user = User.find_by(id: params[:id])
        if @user     
            @user_books = Book.all.where(user_id: @user[:id])
        else
            redirect_to(root_path, alert: "No User Found") and return 
        end

    end

    def address_form

    end

    def create_address
        @user = User.(id: current_user.id)
        if @user.update(address_params)
            redirect_to user_path(@user), notice: 'Address was successfully updated.'
        else
            redirect_to address_form_path, alert: "can't update address"
        end
    end

    private
    # Never trust parameters from the scary internet, only allow the white list through.
    def address_params
        params.require(:address).permit(:lat, :lng, :formatted_address, :state, :city, :zipcode, :country)
        
    end
end
