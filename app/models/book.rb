class Book < ApplicationRecord
    serialize :reviews, Array
    # belongs_to :owner_id
    # belongs_to :renter_id
    # has_many :rate_id
    has_many :book_genres
    has_many :genres, through: :book_genres

    has_many :reviews, through: :users

    # FOR IMAGES
    has_one_attached :front_cover
    has_one_attached :back_cover
    has_many_attached :features

    # SEARCH-KICK
    searchkick word_start: [:title, :author, :genres, :description, :owner_name]

    # # FOR UPDATE
    # after_commit :reindex_book
    # def reindex_book
    #     Book.reindex
    # end

    def self.genre(name)
        Genre.find_by!(name: name).books
      end
    
      def self.genre_counts
        Genre.select('genres.*, count(book_genres.genre_tag) as count').joins(:book_genres).group('book_genres.genre_tag')
      end
    
      def genre_tag_list
        genres.map(&:name).join(', ')
      end
    
      def genre_tag=(names)
        self.genres = names.split(',').map do |n|
            Genre.where(name: n.strip)
        end
      end

      def self.review(book_id)
        Review.find_by!(reviewing_id: book_id).reviews
      end
    
      def review=(review)
        self.review = if self.review.empty?
          Array.new
        end
        self.review << Review.find_by(reviewing_id: book_id)
      end


    def search_data
        {
        title: title,
        author: author,
        genres: genres,
        description: description,
        owner_name: owner_name,
        owner_id: owner_id,
        }
    end
end
