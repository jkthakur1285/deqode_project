require 'rails_helper'

RSpec.describe Category, type: :model do
  require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

  describe 'validations' do

    it 'has blank name' do
      category = FactoryBot.build(:category, name: nil)
      expect(category.save).to be_falsy
    end

    it 'has name in correct format' do
      category = FactoryBot.build(:category, name: "Fashion")
      expect(category.save).to be_truthy
    end

  end
end
