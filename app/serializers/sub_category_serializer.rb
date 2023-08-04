class SubCategorySerializer < ActiveModel::Serializer
  attributes :id,:name,:category_id,:category_name

  belongs_to :category

  def category_name
    object.category.name
  end

end
