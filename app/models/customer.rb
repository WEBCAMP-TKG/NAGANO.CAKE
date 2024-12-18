class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable



   has_many :cart_items, dependent: :destroy
   has_many :orders
   has_many :addresses, dependent: :destroy
   
   #指定したカラムのメソッドがtrueの場合、trueを返す 
  def active_for_authentication?
    super && (is_active == true)
  end
   
   
   def full_name
     "#{last_name} #{first_name}"
   end

   def full_name_kana
     "#{last_name_kana} #{first_name_kana}"
   end
end