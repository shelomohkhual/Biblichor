class Book < ApplicationRecord
    belongs_to :owner, { :class_name => "User"}
    belongs_to :renter, { :class_name => "User"}
    has_many :rents, { :class_name => "User", :foreign_key => :book_id }
    has_many :rates, { :class_name => "Rate", :foreign_key => :book_id }
    has_and_belongs_to_many :genre
    # FOR IMAGES
    has_one_attached :front_cover
    has_one_attached :back_cover
    has_many_attached :features

    # SEARCH-KICK
    searchkick word_start: [:title, :author, :genre, :description, :owner_name]
    # searchkick callbacks: :async

    # FOR UPDATE
    # after_commit :reindex_book
    # def reindex_book
    #     Book.reindex
    # end

    def search_data
        {
        title: title,
        author: author,
        genre: genre,
        description: description,
        owner_name: owner_name,
        }
    end

    
end
