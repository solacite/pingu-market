class Order < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true

  after_create :reduce_product_inventory

  private

  def reduce_product_inventory
    Rails.logger.debug "DEBUG: reduce_product_inventory called for Order #{self.id}."
    Rails.logger.debug "DEBUG: Product ID: #{product_id}, Current Inventory: #{product.inventory_count.inspect}, Quantity to decrease: #{quantity.inspect}"

    if product && product.inventory_count
      product.decrement!(:inventory_count, quantity)
      Rails.logger.debug "DEBUG: Inventory updated! New inventory for Product #{product_id}: #{product.inventory_count}"
    else
      Rails.logger.error "ERROR: Product or inventory_count missing for Order #{self.id}. Product: #{product.inspect}"
    end
  rescue => e
    Rails.logger.error "ERROR in reduce_product_inventory for Order #{self.id}: #{e.message}"
  end
end