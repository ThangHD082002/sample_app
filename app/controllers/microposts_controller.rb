class MicropostsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = "Micropost created"
      redirect_to root_url
    else
      @pagy, @feed_items = pagy current_user.feed, items: 10
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = "Micropost deleted"
    else
      flash[:danger] = "Deleted fail"
    end
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit :content
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = "micropost invalid"
    redirect_to request.referer || root_url
  end
end
