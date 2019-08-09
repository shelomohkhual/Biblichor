class UsersController < ApplicationController
    

    def index
        Book.all.empty? ? nil : @books = Book.all
    end

    # def search  
    #     if params[:query].blank?  
    #       redirect_to(root_path, alert: "Empty field!") and return  
    #     else  
    #         search = params[:query].present? ? params[:query] : nil
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
end
