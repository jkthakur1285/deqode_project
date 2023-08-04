class CategoriesController < ApplicationController
  before_action :authorize_request, except: [:index]
  before_action :find_category, except: %i[create index]

  def index
    @categories = Category.all
    render json: @categories, adapter: :json, status: :ok
  end

  def show
    render json: @category, adapter: :json, status: :ok
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      render json: @category, adapter: :json, status: :created
    else
      render json: { errors: @category.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    unless @category.update(category_params)
      render json: { errors: @category.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    if @category.destroy
      render json: { message: "category deleted" }, status: :ok
    else
      render json: { message: "something went wrong!", errors: @category.errors }, status: :unprocessable_entity
    end
  end

  private
  def find_category
    @category = Category.find_by_id!(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Category not found' }, status: :not_found
  end

  def category_params
    params.permit( :id, :name)
  end
end
