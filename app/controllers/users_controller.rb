class UsersController < ApplicationController
    

    def index
        Book.all.empty? ? nil : books = Book.all.order('created_at DESC')
        @books = if books.size > 4
            books[0..3]
        else
            books
        end
    end

    # def search  
    #     if params[:search].blank?  
    #       redirect_to(root_path, alert: "Empty field!") and return  
    #     else  
    #         search = params[:term].present? ? params[:term] : nil
    #         @search_result = if search
    #             User.search(search)
    #         else
    #             User.all
    #         end
    #     end
    # end  

    def show
        @user = User.find_by(id: params[:id])
        if @user
            # byebug
            @user_books = Book.all.where(owner_id: @user[:id])
            if @user.username == nil && @user.name == nil
                @username = "You Know Who"
            else 
                @user.username == nil ? @username = @user.name : @username = @user.username
            end 
        else
            redirect_to(root_path, alert: "No User Found") and return 
        end

    end

    def address_form

    end

    def create_address
        byebug
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
        byebug
    end
end
