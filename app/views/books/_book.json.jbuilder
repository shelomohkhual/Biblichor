json.extract! book, :id, :title, :author, :published_date, :description, :genre, :front_cover, :back_cover, :features, :renting, :owner_id, :created_at, :updated_at
json.url book_url(book, format: :json)
