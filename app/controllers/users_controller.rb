class UsersController < ApplicationController

  def show
    @user = User.find_by_id(params[:id])
    return render_not_found if @user.blank?
  end
end
