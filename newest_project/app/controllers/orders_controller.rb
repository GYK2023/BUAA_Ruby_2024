class OrdersController < ApplicationController
  before_action :authenticate_user!

  # 显示当前用户的订单列表
  def index
    @orders = current_user.orders
  end

  def show
    @order = current_user.orders.find_by(id: params[:id])
  end

  # 显示创建新订单的页面
  def new
    @order = current_user.orders.new
    @cart_items = current_user.cart.cart_items.includes(:product)
    @user_addresses = current_user.addresses
    @selected_address_id = params[:user_address_id] || @user_addresses.find_by(default: true)&.id
    @selected_address = @user_addresses.find_by(id: @selected_address_id)
  end

  def create
    # 确保选中的地址 ID 传递给订单
    @order = current_user.orders.new(order_params)
    @order.address_id = params[:order][:user_address_id] # 确保正确设置 address_id

    @order.address = current_user.addresses.find_by(id: @order.address_id)
  
    @order.status = "待发货"
    @order.total_price = current_user.cart.total_price
  
    Rails.logger.debug("哈机密哈机密哈机密哈机密")
    Rails.logger.debug(@order.status)

    if @order.save
      # 将购物车中的商品转移到订单中
      current_user.cart.cart_items.each do |cart_item|
        @order.order_items.create!(
          product: cart_item.product,
          quantity: cart_item.quantity,
          price: cart_item.product.price
        )
      end
      current_user.cart.cart_items.destroy_all
      redirect_to order_path(@order), notice: "订单已成功创建！"
    else
      Rails.logger.error "Order creation failed: #{@order.errors.full_messages.join(', ')}"
      @cart_items = current_user.cart.cart_items.includes(:product)
      @user_addresses = current_user.addresses
      render :new, alert: "订单创建失败，请检查填写信息。"
    end
  end
  
  
  

  private

  # 允许的参数
  def order_params
    params.require(:order).permit(:user_address_id)
  end
end
