require 'rails_helper'
require 'json_web_token'

RSpec.describe CategoriesController, type: :controller do
  let(:valid_attributes) { { name: "Fashion" } }
  let(:invalid_attributes) { { name: nil } }
  let(:category) { FactoryBot.create(:category) }
  let(:user) { FactoryBot.create(:user) }
  let(:token) do
    JsonWebToken.encode(user_id: user.id)
  end
  let(:auth_headers) { JsonWebToken.decode(token) }
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to have_http_status(:ok)
    end
    it 'assigns @categories with all categories' do
      category1 = FactoryBot.create(:category)
      category2 = FactoryBot.create(:category)
      get :index
      expect(assigns(:categories)).to match_array([category1, category2])
    end
  end

  describe 'GET #show' do
    before do
      request.headers['Authorization'] = token
    end
    it 'returns a success response' do
      get :show, params: { id: category.id }
      expect(response).to have_http_status(:ok)
    end

    it 'assigns the requested category to @category' do
      get :show, params: { id: category.id }
      expect(assigns(:category)).to eq(category)
    end

    it 'returns a not_found response when category not found' do
      get :show, params: { id: 'nonexistent_id' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST #create' do
    before do
      request.headers['Authorization'] = token
    end
    it 'creates a new category' do
      expect {
        post :create, params: valid_attributes
      }.to change(Category, :count).by(1)
    end

    it 'returns a created response' do
      post :create, params: valid_attributes
      expect(response).to have_http_status(:created)
    end

    it 'returns a unprocessable_entity response when invalid params are provided' do
      invalid_params = { name: nil }
      post :create, params: invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH #update' do
    before do
      request.headers['Authorization'] = token
    end

    it 'updates the category' do
      new_name = 'Updated Category'
      patch :update, params: { id: category.id, name: new_name }
      category.reload
      expect(category.name).to eq(new_name)
    end

    it 'returns a unprocessable_entity response when invalid params are provided' do
      patch :update, params: { id: category.id, name: nil }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE #destroy' do
    before do
      request.headers['Authorization'] = token
    end

    it 'destroys the category' do
      category_temp = FactoryBot.create(:category)
      expect {
        delete :destroy, params: { id: category_temp.id }
      }.to change(Category, :count).by(-1)
    end

    it 'returns a success response' do
      delete :destroy, params: { id: category.id }
      expect(response).to have_http_status(:ok)
    end
  end
end
