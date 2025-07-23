class Product < ApplicationRecord
  include Notifications

  has_many :subscribers, dependent: :destroy
  has_many :orders
  has_one_attached :featured_image
  has_rich_text :description

  validates :name, presence: true
  # Add presence: true here to ensure inventory_count is never nil
  validates :inventory_count, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # This callback will run after a product is updated and committed to the database
  # if `back_in_stock?` returns true.
  after_update_commit :notify_subscribers, if: :back_in_stock?

  def back_in_stock?
    # Ensure inventory_count_previously_was is safely converted to an integer
    # before calling .zero? on it.
    # This also checks that the inventory actually increased from zero to above zero.
    inventory_count_previously_was.to_i.zero? && inventory_count.to_i > 0
  end

  def notify_subscribers
    subscribers.each do |subscriber|
      # Assuming ProductMailer and its `in_stock` method exist
      ProductMailer.with(product: self, subscriber: subscriber).in_stock.deliver_later
    end
  end

  def in_stock?
    # This method is already robust with .to_i
    inventory_count.to_i > 0
  end
end