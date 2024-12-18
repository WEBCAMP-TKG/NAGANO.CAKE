
class Address < ApplicationRecord
  belongs_to :customer

  validates :postal_code, presence: true
  validates :address, presence: true
  validates :name, presence: true

  def full_address_with_postal_and_name  # /naganocake/app/views/public/orders/new.html.erbの、お届け先用のもの
    "〒#{self.postal_code} #{self.address} #{self.name}"
  end

end
