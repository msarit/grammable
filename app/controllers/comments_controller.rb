class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    @gram = Gram.find_by_id(params[:gram_id])
    return render_not_found if @gram.blank?
    
    @gram.comments.create(comment_params.merge(user: current_user))
    redirect_to gram_path(@gram)
  end

  def destroy
    @gram = Gram.find_by_id(params[:gram_id])
    return render_not_found if @gram.blank?

    @comment = @gram.comments.find(params[:id])
    @comment.destroy
    redirect_to gram_path(@gram)
  end

  private

  def comment_params
    params.require(:comment).permit(:message, :user_id, :gram_id)
  end
end
