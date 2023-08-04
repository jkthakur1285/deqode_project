require 'rails_helper'
require 'json_web_token'

RSpec.describe SubCategoriesController, type: :controller do
  let(:category) { FactoryBot.create(:category) }
  let!(:sub_category) { FactoryBot.create(:sub_category, category: category) }
  let(:valid_attributes) { { name: 'New Sub Category', category_id: category.id } }
  let(:invalid_attributes) { { name: nil } }
  let(:user) { FactoryBot.create(:user) }
  let(:token) do
    JsonWebToken.encode(user_id: user.id)
  end
  let(:auth_headers) { JsonWebToken.decode(token) }
  let(:category) { FactoryBot.create(:category) }

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: { category_id: category.id }
      expect(response).to have_http_status(:ok)
    end

    it 'assigns @category' do
      get :index, params: { category_id: category.id }
      expect(assigns(:category)).to eq(category)
    end

    it 'returns a not_found response when category not found' do
      get :index, params: { category_id: 'nonexistent_id' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'GET #show' do
    before do
      request.headers['Authorization'] = token
    end
    it 'returns a success response' do
      get :show, params: { category_id: category.id, id: sub_category.id }
      expect(response).to have_http_status(:ok)
    end

    it 'assigns the requested sub_category to @sub_category' do
      get :show, params: { category_id: category.id, id: sub_category.id }
      expect(assigns(:sub_category)).to eq(sub_category)
    end

    it 'returns a not_found response when sub_category not found' do
      get :show, params: { category_id: category.id, id: 'nonexistent_id' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST #create' do
    before do
      request.headers['Authorization'] = token
    end
    it 'creates a new sub_category' do
      expect {
        post :create, params: valid_attributes
      }.to change(SubCategory, :count).by(1)
    end

    it 'returns a created response' do
      post :create, params: valid_attributes
      expect(response).to have_http_status(:created)
    end

    it 'returns a unprocessable_entity response when invalid params are provided' do
      invalid_params = { name: nil, category_id: category.id }
      post :create, params: invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT #update' do
    before do
      request.headers['Authorization'] = token
    end
    context 'with valid attributes' do
      it 'updates the sub category' do
        new_name = 'Updated Sub Category Name'
        put :update, params: { category_id: category.id, id: sub_category.id, name: new_name }
        sub_category.reload
        expect(sub_category.name).to eq(new_name)
      end

      it 'returns a success response' do
        put :update, params: { category_id: category.id, id: sub_category.id }
        expect(response).to have_http_status(:ok)
      end

      it 'renders a JSON success message' do
        put :update, params: { category_id: category.id, id: sub_category.id }
        expect(JSON.parse(response.body)).to eq('message' => 'sub category updated')
      end
    end

    context 'with invalid attributes' do
      it 'returns a unprocessable_entity response' do
        put :update, params: { category_id: category.id, id: sub_category.id, name: nil }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders errors in JSON response' do
        put :update, params: { category_id: category.id, id: sub_category.id, name: nil }
        errors = JSON.parse(response.body)['errors']
        expect(errors).to be_present
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      request.headers['Authorization'] = token
    end

    it 'destroys the sub_category' do
      expect {
        delete :destroy, params: { category_id: category.id, id: sub_category.id }
      }.to change(SubCategory, :count).by(-1)
    end

    it 'returns a success response' do
      delete :destroy, params: { category_id: category.id, id: sub_category.id }
      expect(response).to have_http_status(:ok)
    end
  end
end