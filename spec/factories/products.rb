FactoryBot.define do
  factory :product do
    name { Faker::Commerce::product_name }
    description { "This is a test product" }
    price { Faker::Commerce::price }
    association :category, factory: :category
    association :sub_category, factory: :sub_category
  end
end
