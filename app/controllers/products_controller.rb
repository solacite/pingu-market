class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy buy ]
  allow_unauthenticated_access only: %i[ index show buy ]

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

    if @product.nil?
      Rails.logger.error "CRITICAL ERROR: @product is NIL in buy action even after set_product for ID: #{params[:id]}! This means set_product likely failed or the redirect didn't halt execution."
      redirect_to products_path, alert: 'Error: Product data missing for purchase. Please try again.' and return
    end

    Rails.logger.debug "DEBUG: @product object (after set_product): #{@product.inspect}"
    Rails.logger.debug "DEBUG: Is user authenticated?: #{authenticated?.inspect}"
    Rails.logger.debug "DEBUG: current_user: #{current_user.inspect}"
    Rails.logger.debug "DEBUG: Product inventory_count: #{@product.inventory_count}"
    Rails.logger.debug "DEBUG: Product in_stock?: #{@product.in_stock?}"


    if @product.in_stock?
      @order = Order.new(
        product: @product,
        quantity: 1,
        total_price: 1.00,
        status: 'completed'
      )

      if @order.save
        @product.decrement!(:inventory_count)
        Rails.logger.debug "DEBUG: Inventory updated! New count for Product ID #{@product.id}: #{@product.inventory_count}"

        redirect_to @order, notice: 'Purchase successful! Your order has been placed.'
      else
        Rails.logger.error "Order save failed for product ID #{params[:id]}: #{@order.errors.full_messages.join(', ')}"
        redirect_to @product, alert: "Could not complete purchase due to order error: #{@order.errors.full_messages.join(', ')}. Please try again."
      end
    else
      Rails.logger.warn "WARN: Attempt to buy out-of-stock product ID: #{params[:id]}"
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
      Rails.logger.debug "DEBUG: set_product BEFORE find. params[:id] = '#{params[:id]}'"
      @product = Product.find(params[:id])
      Rails.logger.debug "DEBUG: set_product AFTER find. @product = #{@product.inspect}"
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error "ERROR: Product with ID '#{params[:id]}' NOT FOUND by Product.find. Exception: #{e.message}"
      redirect_to products_path, alert: 'Product not found.' and return
    end

    def product_params
      params.expect(product: [ :name, :description, :featured_image, :inventory_count ])
    end
end
