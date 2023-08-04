FactoryBot.define do
  factory :sub_category do
    name { Faker::Commerce::brand }
    association :category, factory: :category
  end
end
