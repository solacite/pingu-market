class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  allow_unauthenticated_access only: %i[ index show ]

  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def buy
    if @product.in_stock?
      @order = current_user.orders.new(
        product: @product,
        quantity: 1,
        total_price: @product.price,
        status: 'completed'
      )

      if @order.save
        redirect_to @order, notice: 'Purchase successful! Your order has been placed.'
      else
        redirect_to @product, alert: 'Could not complete purchase. Please try again.'
      end
    else
      redirect_to @product, alert: 'Sorry, this product is out of stock.'
    end
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to @product
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.expect(product: [ :name, :description, :featured_image, :inventory_count ])
    end
end
