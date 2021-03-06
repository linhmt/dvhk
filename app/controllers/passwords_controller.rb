class PasswordsController < ApplicationController
  before_filter :authenticate_user!

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update_with_password(params[:user])
      sign_in(@user, :bypass => true)
      redirect_to root_path, :notice => "Password updated!"
    elsif params[:user][:short_name]
      @user.short_name = params[:user][:short_name]
      @user.save!
      redirect_to root_path, :notice => "User details updated!"
    else
      render :edit
    end
  end
end