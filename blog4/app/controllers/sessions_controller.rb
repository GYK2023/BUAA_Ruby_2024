class SessionsController < ApplicationController
    def new
    end
    def create
      @user = User.find_by(username: params[:username])
      if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect_to user_blogs_path(@user.username), notice: "Logged in successfully."
      else
        if @user.nil?
            Rails.logger.info "Username not found."
            flash.now[:alert] = "Username not found."
        else
            Rails.logger.info "Invalid password."
            flash.now[:alert] = "Invalid password."
        end
        render :new, status: :unauthorized
      end
    end
    def destroy
      session.delete(:user_id)
      redirect_to login_path, notice: "Logged out successfully."
    end
end