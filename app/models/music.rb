class Music < ApplicationRecord
  validates :title, :composer, :style, :arranger, :category, presence: true
end
