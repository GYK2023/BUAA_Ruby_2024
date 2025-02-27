class CartItemsController < ApplicationController
    before_action :set_cart
    before_action :authenticate_user!
    def create
      product = Product.find(params[:product_id])
      @cart = current_user.cart || current_user.create_cart
      cart_item = @cart.cart_items.find_or_initialize_by(product: product)
      if cart_item.new_record?
        cart_item.quantity = params[:quantity] || 1
      else
        cart_item.quantity += 1
      end
      if cart_item.save
        redirect_to cart_path, notice: "商品已加入购物车！"
      else
        redirect_to products_path, alert: "无法添加商品到购物车。"
      end
    end

    def update_quantity
      @cart_item = CartItem.find(params[:id])
      new_quantity = params[:cart_item][:quantity].to_i
      if new_quantity >= 0
        if new_quantity == 0
          @cart_item.destroy
          redirect_to cart_path, notice: '商品已从购物车移除！'
        else
          @cart_item.update(quantity: new_quantity)
          redirect_to cart_path
        end
      else
        redirect_to cart_path, alert: '商品数量不能小于 0！'
      end
    end
  
    def destroy
      cart_item = @cart.cart_items.find(params[:id])
      cart_item.destroy
      redirect_to cart_path, notice: '商品已从购物车移除。'
    end
  
    private
  
    def set_cart
      @cart = current_cart
    end
  end
  