require 'rails_helper'
require 'json_web_token'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) { { email: "test_user5@gmail.com", password: "123456", password_confirmation: "123456" } }
  let(:invalid_attributes) { { email: nil, password: "123456", password_confirmation: "123456" } }
  let(:user) { FactoryBot.create(:user) }
  let(:token) do
    JsonWebToken.encode(user_id: user.id)
  end
  let(:auth_headers) { JsonWebToken.decode(token) }

  describe "GET #index" do
    it "returns a success response with a list of users" do
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["users"]).to be_an_instance_of(Array)
    end
  end

  describe 'GET #show' do
    before do
      request.headers['Authorization'] = token
    end
    it 'returns a success response' do
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:ok)
    end

    it 'assigns the requested user to @user' do
      get :show, params: { id: user.id }
      expect(assigns(:user)).to eq(user)
    end

    it 'returns a not_found response when user not found' do
      get :show, params: { id: 'nonexistent_id' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST #create' do

    it 'creates a new user' do
      expect {
        post :create, params: valid_attributes
      }.to change(User, :count).by(1)
    end

    it 'returns a created response' do
      post :create, params: valid_attributes
      expect(response).to have_http_status(:created)
    end

    it 'returns a unprocessable_entity response when invalid params are provided' do
      post :create, params: invalid_attributes
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PATCH #update' do
    before do
      request.headers['Authorization'] = token
    end

    it 'updates the user' do
      new_email = 'new_email@example.com'
      patch :update, params: { id: user.id, email: new_email }
      user.reload
      expect(user.email).to eq(new_email)
    end

    it 'returns a unprocessable_entity response when invalid params are provided' do
      patch :update, params: { id: user.id, email: 'invalid_email.com' }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE #destroy" do
    before do
      request.headers['Authorization'] = token
    end
    it "destroys the user" do
      user # Create the user before the request to ensure it exists.
      expect {
        delete :destroy, params: { id: user.id }
      }.to change(User, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end