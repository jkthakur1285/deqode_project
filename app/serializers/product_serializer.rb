class ProductSerializer < ActiveModel::Serializer
  attributes :id,:name,:description,:price,:category_name,:sub_category_name

  belongs_to :category
  belongs_to :sub_category

  def category_name
    object.category.name
  end

  def sub_category_name
    object.sub_category.name
  end
end
