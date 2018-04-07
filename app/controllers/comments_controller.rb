class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    @gram = Gram.find_by_id(params[:gram_id])
    if @gram.blank?
      return render_not_found
      else
      @gram.comments.create(comment_params.merge(user: current_user))
      redirect_to root_path
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:message, :user_id, :gram_id)
  end
end
