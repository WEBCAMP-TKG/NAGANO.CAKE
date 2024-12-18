class Public::CartItemsController < ApplicationController
  before_action :authenticate_customer!

  # GET	/cart_items
  def index
    @cart_items = current_customer.cart_items.includes(:item) # 現在の顧客のカートアイテムを取得
  end

# PATCH	/cart_items/:id
  def update
    @cart_item = CartItem.find(params[:id])
    if @cart_item.update(amount: params[:amount]) # 数量を更新
      redirect_to cart_items_path, notice: '数量が更新されました'
    else
      redirect_to cart_items_path, alert: '数量の更新に失敗しました'
    end
  end

# DELETE	/cart_items/:id
  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    redirect_to cart_items_path, notice: '商品がカートから削除されました' # カートの一覧ページにリダイレクト
  end

# DELETE	/cart_items/all_destroy
  def all_destroy
    current_customer.cart_items.all_destroy # 現在の顧客のカートアイテムをすべて削除
    redirect_to cart_items_path, notice: 'カートが空になりました'
  end

# POST	/cart_items
  def create
    if customer_signed_in?
      quantity = params[:quantity].to_i
      logger.debug "Quantity: #{quantity}, Item ID: #{params[:item_id]}"

      if quantity > 0
        # 既に同じ商品がカートに存在するか確認
        existing_cart_item = current_customer.cart_items.find_by(item_id: params[:item_id])

        if existing_cart_item
          # 既存のカートアイテムがある場合、現在の数量と追加したい数量の合計が10を超えないか確認
          new_quantity = existing_cart_item.amount + quantity
          if new_quantity > 10
            redirect_to item_path(params[:item_id]), alert: 'カート内の数量は10個までです'
          else
            existing_cart_item.amount = new_quantity
            if existing_cart_item.save
              redirect_to cart_items_path, notice: 'カート内の商品の数量が更新されました'
            else
              redirect_to item_path(params[:item_id]), alert: '商品の数量を更新できませんでした'
            end
          end
        else
          # 既存のカートアイテムがない場合、新規作成。ただし、数量は10個以下にする
          if quantity > 10
            redirect_to item_path(params[:item_id]), alert: 'カートに追加できる最大数量は10個です'
          else
            @cart_item = CartItem.new(item_id: params[:item_id], amount: quantity, customer_id: current_customer.id)
            if @cart_item.save
              redirect_to cart_items_path, notice: '商品がカートに追加されました'
            else
              redirect_to item_path(params[:item_id]), alert: '商品をカートに追加できませんでした'
            end
          end
        end
      else
        redirect_to item_path(params[:item_id]), alert: '個数を選択してください'
      end
    else
      flash[:alert] = "ログインしてください。"
      redirect_to item_path(params[:item_id])
    end
  end
end
end
