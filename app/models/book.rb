class Book < ApplicationRecord
    has_one_attached :front_cover
    has_one_attached :back_cover
    has_many_attached :features
    
end
