class ProductsController < ApplicationController
  # 在执行某些操作前，找到对应的产品
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # 展示所有产品
  def index
    @products = Product.all
  end

  # GET /products/:id
  # 展示单个产品
  def show
  end

  # GET /products/new
  # 渲染新建表单
  def new
    @product = Product.new
  end

  # POST /products
  # 创建新产品
  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product, notice: "成功新增商品"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /products/:id/edit
  # 渲染编辑表单
  def edit
  end

  # PATCH/PUT /products/:id
  # 更新产品
  def update
    if @product.update(product_params)
      redirect_to @product, notice: "商品信息已成功更新"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /products/:id
  # 删除产品
  def destroy
    @product.destroy
    redirect_to products_path, notice: "商品已成功删除"
  end

  private

  # 使用 before_action 的方法，用于找到当前产品
  def set_product
    @product = Product.find(params[:id])
  end

  # 强参数：限制允许通过表单提交的参数
  def product_params
    params.require(:product).permit(:name, :description, :price, :stock, :sales, :image)
  end
end
