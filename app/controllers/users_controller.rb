class UsersController < ApplicationController
    def index
        @books = Book.all
    end
end
