class Api::CommentsController < Api::ApplicationController
  def destroy
    comment = KcComments::Comment.find params[:id]
    comment.destroy if !comment.blank?
    render json: {}
  end
end