class Rate < ApplicationRecord
    has_many :rater
    has_many :book
    has_many :user
end
