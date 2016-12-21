class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def index
  	@profile = current_user.profile
  end

  def new
  	@profile = Profile.new
  end

  def create
  end

  def update
  end

  def edit
  end

  def show
  	@profile = current_user.profile.first_or_create
  end

  def profile_params
      params.require(:profile).permit(:pin)
    end
end
