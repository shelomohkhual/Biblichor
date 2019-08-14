class Genre < ApplicationRecord
    has_many :book_genres,dependent: :destroy
    has_many :books, through: :book_genres,dependent: :destroy
end
