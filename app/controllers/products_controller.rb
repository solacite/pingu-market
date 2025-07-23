class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy buy ]
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
    Rails.logger.debug "DEBUG: Entering buy action. Product ID: #{params[:id]}"
    Rails.logger.debug "DEBUG: @product object: #{@product.inspect}"

    if @product.nil?
      Rails.logger.error "CRITICAL ERROR: @product is NIL in buy action even after set_product for ID: #{params[:id]}!"
      redirect_to products_path, alert: 'Error: Product data missing for purchase. Please try again.' and return
    end

    if @product.in_stock?
      @order = Order.new(
        product: @product,
        quantity: 1,
        total_price: @product.price,
        status: 'completed'
      )
      
      @order.user = current_user if user_signed_in?

      if @order.save
        redirect_to @order, notice: 'Purchase successful! Your order has been placed.'
      else
        Rails.logger.error "Order save failed for product ID #{params[:id]}: #{@order.errors.full_messages.join(', ')}"
        redirect_to @product, alert: 'Could not complete purchase due to order error. Please try again.'
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
