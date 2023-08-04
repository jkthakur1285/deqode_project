class ProductsController < ApplicationController
  before_action :authorize_request, except: [:index]
  before_action :find_product, except: %i[create index]

  def index
    @products = Product.all
    render json: @products, adapter: :json, status: :ok
  end

  def show
    render json: @product, adapter: :json, status: :ok
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      render json: @product, adapter: :json, status: :created
    else
      render json: { errors: @product.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    unless @product.update(product_params)
      render json: { errors: @product.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: { message: "product updated" }, status: :ok
    end
  end

  def destroy
    if @product.destroy
      render json: { message: "product deleted" }, status: :ok
    else
      render json: { message: "something went wrong!", errors: @product.errors }, status: :unprocessable_entity
    end
  end

  private
  def find_product
    @product = Product.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Product not found' }, status: :not_found
  end

  def product_params
    params.permit( :name, :description, :price, :category_id, :sub_category_id)
  end
end
