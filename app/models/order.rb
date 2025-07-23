class Order < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true

  after_create :reduce_product_inventory

  private

  def reduce_product_inventory
    if product && product.inventory_count
      product.decrement!(:inventory_count, quantity)
    end
  end
end