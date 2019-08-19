class Book < ApplicationRecord
    
    belongs_to :user
    # reviews
    # has_many :reviews
    # has_many :users, through: :reviews
    # Book_generes
    has_many :book_genres, dependent: :destroy
    has_many :genres, through: :book_genres, dependent: :destroy
    # FOR IMAGES
    has_one_attached :front_cover
    has_one_attached :back_cover
    has_many_attached :features

    # SEARCH-KICK
    searchkick word_start: [:title, :author, :description]

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
        description: description
        }
    end
end
