class Book < ApplicationRecord
    belongs_to :owner
    belongs_to :renter
    has_many :rate
    has_many :genre


    # FOR IMAGES
    has_one_attached :front_cover
    has_one_attached :back_cover
    has_many_attached :features

    # SEARCH-KICK
    searchkick word_start: [:title, :author, :genre, :description, :owner_name]

    # FOR UPDATE
    after_commit :reindex_book
    def reindex_book
        Book.reindex
    end

    def search_data
        {
        title: title,
        author: author,
        genre: genre,
        description: description,
        owner_name: owner_name,
        owner_id: owner_id,
        }
    end
end
