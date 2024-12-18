class CartItem < ApplicationRecord
  belongs_to :customer
  belongs_to :item
  validates :item_id, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }

  def add_tax_price
    (self.item.price * 1.10).round
   end

end
