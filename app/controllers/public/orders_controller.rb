class Public::OrdersController < ApplicationController
  class Public::OrdersController < ApplicationController
    before_action :authenticate_customer!
    before_action :cart_items_blank?, only: [:new]
    before_action :payment_method_blank?, only: [:confirm, :create]
   
  def new
    @order = Order.new
    @addresses = Address.where(customer_id: current_customer.id)
  end


  def confirm
    @customer = current_customer
    @cart_items = @customer.cart_items
    @order = Order.new
    @order.shipping_fee = 800
    @address = Address.find_by(id: params[:order][:selected_address].to_i)
    @order.payment_method = params[:order][:payment_method]

    if params[:order][:select_address] == "0"
      @order.post_code = current_customer.post_code
      @order.address = current_customer.address
      @order.name = current_customer.family_name + current_customer.first_name
    elsif params[:order][:select_address] == "1"
      @address = Address.find(params[:order][:selected_address])
      @order.post_code = @address.post_code
      @order.address = @address.address
      @order.name = @address.name
    elsif params[:order][:select_address] == "2"
      @order.post_code = params[:order][:post_code]
      @order.address = params[:order][:address]
      @order.name = params[:order][:name]
    end
  end


  def thanx
  end


  def create
    @customer = current_customer
    @cart_items = @customer.cart_items
    @order = Order.new(order_params)
    @order.customer_id = current_customer.id
    @order.status = 'waiting_for_payment' 
    if @order.save
      @cart_items.each do |cart_item|
        order_detail = OrderDetail.new
        order_detail.order_id = @order.id
        order_detail.item_id = cart_item.item_id
        order_detail.price = cart_item.item.price
        order_detail.amount = cart_item.amount
        order_detail.making_status = 'not_create'
        order_detail.save 
      end
      # カートを空にする処理（注文が完了した後はカートをクリア）
      @cart_items.destroy_all
      redirect_to orders_thanx_path
    else
      redirect_to root_path, alert: 'カートが空です'
    end
  end


  def index
    @orders = Order.where(customer_id: current_customer.id)
    @order_details = OrderDetail.all
  end


  def show
    @order = Order.find(params[:id])
  end




  private


  def order_params
    params.require(:order).permit(:payment_method, :post_code, :address, :name, :shipping_fee, :total_price)
  end


  def order_detail_params
    order_details = params.require(:order_detail)
    permitted_params = order_details.map do |order_detail|
      order_detail.permit(:item_id, :price, :amount, :making_status)
    end
    permitted_params
  end


  def cart_items_blank?
    if CartItem.all.blank?
      redirect_to root_path, alert: 'カートが空です'
    end
  end


  def payment_method_blank?
    if params[:order].nil? || params[:order][:payment_method].blank?
      redirect_to root_path, alert: "リンクが無効です"
    end
  end
end
end
