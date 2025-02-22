class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_user, only: :create
  before_action :load_relationship, only: :destroy

  def create
    current_user.follow(@user)
    respond_to do |format|
      format.html redirect_to @user
      format.js
    end
  end

  def destroy
    @user = @relationship.followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html redirect_to @user
      format.js
    end
  end

  private

  def load_user
    @user = User.find_by(id: params[:followed_id])
    # handle when relationship is nil
  end

  def load_relationship
    @relationship = Relationship.find_by(id: params[:id])
    # handle when relationship is nil
  end
end
