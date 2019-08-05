class UsersController < ApplicationController
    def index
        Book.all.empty? ? nil : @books = Book.all
    end
end
