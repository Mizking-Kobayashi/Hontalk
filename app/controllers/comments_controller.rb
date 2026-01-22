class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @post, notice: "返信を送信しました"
    else
      # 失敗しても元の画面に戻す
      redirect_to @post, alert: "返信に失敗しました"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
