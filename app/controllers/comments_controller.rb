class CommentsController < ApplicationController
  before_action :enforce_commenter_ownership, only: %i[edit update destroy]

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params)
    @comment.commenter = current_user
    if @comment.save
      flash[:success] = "Your comment has been added"
    else
      flash[:error] = "Comment body cannot be blank"
    end
    redirect_to post_path(@post)
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])

    if @comment.update(comment_params)
      redirect_to post_path(@comment.commentable_id)
    else
      flash.now[:error] = "Body can't be blank"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:success] = "Comment deleted"

    redirect_to root_path, status: :see_other
  end

  private

  def comment_params
    params.require(:comment).permit(:commenter, :commentable, :body)
  end

  def enforce_commenter_ownership
    return if Comment.find(params[:id]).commenter == current_user

    flash[:error] = "You do not own this comment"
    redirect_to root_path
  end
end
