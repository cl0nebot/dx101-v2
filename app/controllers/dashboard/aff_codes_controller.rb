class Dashboard::AffCodesController < ApplicationController
	before_filter :authenticate_user!

  def index
  	  @myaffcodes = AffCode.where(user_id: current_user.id)
  end

  def new
    @aff_code = AffCode.new
  end

  # POST /aff_codes
  # POST /pages.json
  def create
    @aff_code = AffCode.new(aff_code_params)
    @aff_code.user_id = current_user.id

    respond_to do |format|
      if @aff_code.save
        format.html { redirect_to dashboard_aff_codes_path, notice: 'Affiliate Code was successfully created.' }
        format.json { render :show, status: :created, location: @aff_code }
      else
        format.html { render :new }
        format.json { render json: @aff_code.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def aff_code_params
      params.require(:aff_code).permit(:code, :user_id)
    end
end
