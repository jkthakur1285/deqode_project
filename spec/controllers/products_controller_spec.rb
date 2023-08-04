require 'rails_helper'
require 'json_web_token'


RSpec.describe ProductsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:category) { FactoryBot.create(:category) }
  let!(:sub_category) { FactoryBot.create(:sub_category, category: category) }
  let(:valid_attributes) { { name: 'product new',description: "test",price: 100, category_id: category.id, sub_category_id: sub_category.id } }
  let(:invalid_attributes) { { name: '' } }
  let(:token) do
    JsonWebToken.encode(user_id: user.id)
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #show' do
    before do
      request.headers['Authorization'] = token
    end
    it 'returns a successful response' do
      product = FactoryBot.create(:product)
      get :show, params: { id: product.id }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #create' do
    before do
      request.headers['Authorization'] = token
    end
    context 'with valid parameters' do
      it 'creates a new product' do
        expect {
          post :create, params:  valid_attributes
        }.to change(Product, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new product' do
        expect {
          post :create, params: invalid_attributes
        }.not_to change(Product, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end


  describe 'PATCH #update' do
    let(:product) { FactoryBot.create(:product) }
    before do
      request.headers['Authorization'] = token
    end
    context 'with valid parameters' do
      it 'updates the product' do
        patch :update, params: { id: product.id,  name: 'New Name' }
        expect(response).to have_http_status(:ok)
        expect(product.reload.name).to eq('New Name')
      end
    end

    context 'with invalid parameters' do
      it 'does not update the product' do
        patch :update, params: { id: product.id, name: '' }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(product.reload.name).not_to eq('')
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      request.headers['Authorization'] = token
    end
    let!(:product) { FactoryBot.create(:product) }

    it 'destroys the product' do
      expect {
        delete :destroy, params: { id: product.id }
      }.to change(Product, :count).by(-1)
      expect(response).to have_http_status(:ok)
    end
  end
end


