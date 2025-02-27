class OrdersController < ApplicationController
  before_action :authenticate_user!

  # 显示当前用户的订单列表
  def index
    if current_user.is_admin?
      @orders = Order.all
    else
      @orders = current_user.orders
    end
  end

  def show
    if current_user.is_admin?
      @order = Order.all.find_by(id: params[:id])
    else
      @order = current_user.orders.find_by(id: params[:id])
    end
  end

  # 显示创建新订单的页面
  def new
    @order = current_user.orders.new
    @cart_items = current_user.cart.cart_items.includes(:product)
    @user_addresses = current_user.addresses
    @selected_address_id = params[:user_address_id] || @user_addresses.find_by(default: true)&.id
    @selected_address = @user_addresses.find_by(id: @selected_address_id)
  end

  def destroy
    @order = Order.all.find_by(id: params[:id])
    if @order.destroy
      flash[:success] = "订单已成功删除。"
    else
      flash[:error] = "订单删除失败。"
    end
    redirect_to orders_path
  end

  def create
    @order = current_user.orders.new(order_params)
    @order.address_id = params[:order][:user_address_id]
    @order.address = current_user.addresses.find_by(id: @order.address_id)
    @order.status = params[:order][:status] || "待支付"
    @order.total_price = current_user.cart.total_price
  
    @cart_items = current_user.cart.cart_items.includes(:product)

    inventory_error = nil
    @cart_items.each do |cart_item|
      if cart_item.product.stock < cart_item.quantity
        inventory_error = "商品 #{cart_item.product.name} 的库存不足，仅剩 #{cart_item.product.stock} 件。"
        break
      end
    end
  
    if inventory_error
      flash[:error] = inventory_error
      @user_addresses = current_user.addresses
      render :new, status: :unprocessable_entity and return
    end
  
    # 保存订单及其明细
    if @order.save
      @cart_items.each do |cart_item|
        @order.order_items.create!(
          product: cart_item.product,
          quantity: cart_item.quantity,
          price: cart_item.product.price
        )
        if @order.status == "已支付"
          product = cart_item.product
          product.update!(
            stock: product.stock - cart_item.quantity,
            sales: product.sales + cart_item.quantity
          )
        end
      end
      current_user.cart.cart_items.destroy_all
      redirect_to order_path(@order), notice: "订单已成功创建！"
    else
      Rails.logger.error "Order creation failed: #{@order.errors.full_messages.join(', ')}"
      @user_addresses = current_user.addresses
      render :new, alert: "订单创建失败，请检查填写信息。"
    end
  end
  

  def update_status
    @order = Order.find(params[:id])
    inventory_error = nil
  
    if params[:status] == "已支付"
      @order.order_items.each do |order_item|
        product = order_item.product
        if product.stock < order_item.quantity
          inventory_error = "商品 #{order_item.product.name} 的库存不足，仅剩 #{product.stock} 件。"
          break
        end
      end
  
      if inventory_error
        flash[:error] = inventory_error
        redirect_to @order and return
      end
  
      @order.order_items.each do |order_item|
        product = order_item.product
        product.update!(
          stock: product.stock - order_item.quantity,
          sales: product.sales + order_item.quantity
        )
      end
  
      if @order.update(status: "已支付")
        flash[:success] = "成功支付订单！"
      else
        flash[:error] = @order.errors.full_messages.to_sentence
      end
    elsif params[:status] == "已收货"
      if @order.update(status: params[:status])
        flash[:success] = "已确认收货！"
      else
        flash[:error] = @order.errors.full_messages.to_sentence
      end
    elsif current_user.is_admin? && params[:status] == "已发货"
      if @order.update(status: params[:status])
        flash[:success] = "已发货！"
      else
        flash[:error] = @order.errors.full_messages.to_sentence
      end
    elsif current_user.is_admin? && params[:status] == "已完成"
      if @order.update(status: params[:status])
        flash[:success] = "订单完成！"
      else
        flash[:error] = @order.errors.full_messages.to_sentence
      end
    else
      flash[:error] = "无效的订单状态更新请求！"
    end
  
    redirect_to @order
  end
  

  private

  # 允许的参数
  def order_params
    params.require(:order).permit(:user_address_id)
  end
end
