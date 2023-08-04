class Product < ApplicationRecord
  belongs_to :category
  belongs_to :sub_category

  validates :name, :presence => true
  validates :description, :presence => true
  validates :price, :presence => true
end
