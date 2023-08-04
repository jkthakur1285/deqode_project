require 'rails_helper'

RSpec.describe User, type: :model do
  require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

  describe 'validations' do

    it 'has blank email' do
      user = FactoryBot.build(:user, email: nil)
      expect(user.save).to be_falsy
    end

    it 'has blank password' do
      user = FactoryBot.build(:user, password: nil)
      expect(user.save).to be_falsy
    end

    it 'has email in wrong format' do
      user = FactoryBot.build(:user, email: "wrong_email")
      expect(user.save).to be_falsy
    end

    it 'has email in correct format' do
      user = FactoryBot.build(:user, email: "email4@gmail.com",password: "123456", password_confirmation: "123456")
      expect(user.save).to be_truthy
    end

  end

end
