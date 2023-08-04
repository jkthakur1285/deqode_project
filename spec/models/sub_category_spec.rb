require 'rails_helper'

RSpec.describe SubCategory, type: :model do
  describe 'associations' do
    it { should belong_to(:category) }
    it { should have_many(:products).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  context 'when saving a new SubCategory' do
    it 'is valid with valid attributes' do
      sub_category = FactoryBot.build(:sub_category)
      expect(sub_category).to be_valid
    end

    it 'is invalid without a name' do
      sub_category = FactoryBot.build(:sub_category, name: nil)
      expect(sub_category).not_to be_valid
      expect(sub_category.errors[:name]).to include("can't be blank")
    end
  end
end
