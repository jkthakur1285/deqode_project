class SubCategoriesController < ApplicationController
  before_action :authorize_request, except: %i[index show]
  before_action :find_sub_category, except: %i[create index]

  def index
    @category = Category.find(params[:category_id])
    @sub_categories = @category.sub_categories
    render json: @sub_categories, adapter: :json, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Category not found' }, status: :not_found
  end

  def show
    render json: @sub_category, adapter: :json, status: :ok
  end

  def create
    @category = Category.find_by_id!(params[:category_id])
    @sub_category = @category.sub_categories.new(sub_category_params)
    if @sub_category.save
      render json: @sub_category, adapter: :json, status: :created
    else
      render json: { errors: @sub_category.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    unless @sub_category.update(sub_category_params)
      render json: { errors: @sub_category.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: { message: "sub category updated" }, status: :ok
    end
  end

  def destroy
    if @sub_category.destroy
      render json: { message: "sub category deleted" }, status: :ok
    else
      render json: { message: "something went wrong!", errors: @sub_category.errors }, status: :unprocessable_entity
    end
  end

  private
  def find_sub_category
    @category = Category.find(params[:category_id])
    @sub_category = @category.sub_categories.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Sub Category not found' }, status: :not_found
  end

  def sub_category_params
    params.permit( :name, :category_id)
  end
end