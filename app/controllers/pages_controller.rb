class PagesController < ApplicationController
  before_action :set_page, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /pages
  # GET /pages.json
  
  def index
    @pages = Page.all
    @btcusd = ExtQuote.last.val
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    @btcusd = ExtQuote.last.val
    dbtoday = BonusPool.daily.where("DATE(startday) = ?", Date.today).first
    dbtoday.nil? ? @dbonus = 0 : @dbonus = dbtoday.paid_in.round(8)
    wbtoday = BonusPool.weekly.where("DATE(startday) = ?", Date.today.beginning_of_week).first
    wbtoday.nil? ? @wbonus = 0 : @wbonus = wbtoday.paid_in.round(8)
    mbtoday = BonusPool.monthly.where("DATE(startday) = ?", Date.today.beginning_of_month).first
    mbtoday.nil? ? @mbonus = 0 : @mbonus = mbtoday.paid_in.round(8)
    ybtoday = BonusPool.yearly.where("DATE(startday) = ?", Date.today.beginning_of_year).first
    ybtoday.nil? ? @ybonus = 0 : @ybonus = ybtoday.paid_in.round(8)   
  end

  # GET /pages/new
  def new
    @page = Page.new
  end

  # GET /pages/1/edit
  def edit
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(page_params)

    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, notice: 'Page was successfully created.' }
        format.json { render :show, status: :created, location: @page }
      else
        format.html { render :new }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1
  # PATCH/PUT /pages/1.json
  def update
    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to @page, notice: 'Page was successfully updated.' }
        format.json { render :show, status: :ok, location: @page }
      else
        format.html { render :edit }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page.destroy
    respond_to do |format|
      format.html { redirect_to pages_url, notice: 'Page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_page
      @page = Page.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def page_params
      params.require(:page).permit(:title, :meta, :slug, :content)
    end
end
