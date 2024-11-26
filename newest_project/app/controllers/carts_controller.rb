class CartsController < ApplicationController
    before_action :set_cart
  
    def show
        @cart = current_user.cart  # 获取当前用户的购物车
        @cart_items = @cart.cart_items  # 获取购物车中的商品
      end

    def add_item
    @cart = current_cart
    product = Product.find(params[:product_id])
    
    # 查找购物车内是否已有该商品
    cart_item = @cart.cart_items.find_by(product_id: product.id)
    
    if cart_item
        # 增加数量
        cart_item.increment!(:quantity)
    else
        # 添加新的购物车条目
        @cart.cart_items.create(product: product, quantity: 1)
    end
    redirect_to cart_path, notice: "#{product.name} 已加入购物车！"
    end
  
    private
  
    def set_cart
      @cart = current_cart
    end
end
  