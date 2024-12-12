class CartsController < ApplicationController
  before_action :set_cart
  before_action :authenticate_user! 
  def show
    @cart = current_user.cart  # 获取当前用户的购物车
    @cart_items = @cart.cart_items  # 获取购物车中的商品
  end

  # 结算功能
  def checkout
    @cart = current_user.cart
    @order = Order.new(user: current_user, status: :pending, total_price: @cart.total_price)
    @cart.cart_items.each do |cart_item|
      @order.order.items.build(product: cart_item.product, quantity: cart_item.quantity, price: cart_item.product.price)
    end
    if @order.save
      @cart.cart_item.destroy_all # 生成订单后需要删掉所有的购物车信息
      redirect_to order_path(@order), notice: "订单已创建，请填写收货信息"
    else
      redirect_to cart_path, alert: "结算失败，请重试"
    end
  end

  def add_item
    @cart = current_cart
    product = Product.find(params[:product_id])
    cart_item = @cart.cart_items.find_by(product_id: product.id)
    if cart_item
      cart_item.increment!(:quantity)
    else
      @cart.cart_items.create(product: product, quantity: 1)
    end
    redirect_to cart_path, notice: "#{product.name} 已加入购物车！"
  end
  
  private
  
  def set_cart
    @cart = current_cart
  end
end
  