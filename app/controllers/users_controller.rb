class UsersController < ApplicationController
  before_action :authorize_request, except: [:create, :index]
  before_action :find_user, except: %i[create index]

  def index
    @users = User.all
    render json: @users, adapter: :json, status: :ok
  end

  def show
    render json: @user, adapter: :json, status: :ok
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, adapter: :json, status: :created
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    unless @user.update(user_params)
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
  end

  private
  def find_user
    @user = User.find_by_id!(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'User not found' }, status: :not_found
  end

  def user_params
    params.permit( :id, :email, :password, :password_confirmation)
  end
end
