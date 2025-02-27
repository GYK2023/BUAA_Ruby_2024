class FavoritesController < ApplicationController
  before_action :authenticate_user!
  def index
    @favorites = current_user.favorites.includes(:product)
  end
  def create
    @product = Product.find(params[:product_id])
    current_user.favorite_products << @product
    redirect_to products_path, notice: '商品已添加到收藏夹！'
  end

  def destroy
    favorite = current_user.favorites.find_by(params[:id])
    favorite.destroy
    redirect_to products_path, notice: '商品已从收藏夹移除！'
  end
end
