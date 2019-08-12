class Genre < ApplicationRecord
    has_many :book_genres
    has_many :books, through: :book_genres
end
