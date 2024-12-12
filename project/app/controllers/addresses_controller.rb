class AddressesController < ApplicationController
    before_action :authenticate_user! 
  
    def index
      @addresses = current_user.addresses 
    end
  
    def new
      @address = Address.new
    end
  
    def create
      @address = current_user.addresses.new(address_params)
      if @address.save
        redirect_to addresses_path, notice: '地址添加成功'
      else
        render :new
      end
    end
  
    def edit
      @address = current_user.addresses.find(params[:id])
    end
  
    def update
      @address = current_user.addresses.find(params[:id])
      if @address.update(address_params)
        redirect_to addresses_path, notice: '地址更新成功'
      else
        render :edit
      end
    end
  
    def destroy
      @address = current_user.addresses.find(params[:id])
      @address.destroy
      redirect_to addresses_path, notice: '地址已删除'
    end

    def details
      address = current_user.addresses.find(params[:id])
      render json: { success: true, name: address.name, phone_num: address.phone_num, address: address.address }
      rescue ActiveRecord::RecordNotFound
      render json: { success: false, message: "地址未找到" }, status: :not_found
    end
  
    private
  
    def address_params
      params.require(:address).permit(:name, :phone_num, :address, :default)
    end
  end
  