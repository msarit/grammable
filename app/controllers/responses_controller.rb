class ResponsesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]


  def create
    @gram = Gram.find_by_id(params[:gram_id])
    return render_not_found if @gram.blank?

    @comment = @gram.comments.find(params[:comment_id])
    return render_not_found if @comment.blank?

    @comment.responses.create(response_params.merge(user: current_user))
    redirect_to gram_path(@gram)
  end

  def destroy
    @gram = Gram.find_by_id(params[:gram_id])
    return render_not_found if @gram.blank?

    @comment = @gram.comments.find(params[:comment_id])
    return render_not_found if @comment.blank?

    @response = @comment.responses.find(params[:id])
    @response.destroy
    redirect_to gram_path(@gram)
  end

  private

  def response_params
    params.require(:response).permit(:message, :comment_id, :user_id)
  end
end
