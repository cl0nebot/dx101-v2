class BuyBitcoinsController < ApplicationController
  before_action :set_buy_bitcoin, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /buy_bitcoins
  # GET /buy_bitcoins.json
  def index
    @buy_bitcoins = BuyBitcoin.order(:name)
  end

  # GET /buy_bitcoins/1
  # GET /buy_bitcoins/1.json
  def show
  end

  # GET /buy_bitcoins/new
  def new
    @buy_bitcoin = BuyBitcoin.new
  end

  # GET /buy_bitcoins/1/edit
  def edit
  end

  # POST /buy_bitcoins
  # POST /buy_bitcoins.json
  def create
    @buy_bitcoin = BuyBitcoin.new(buy_bitcoin_params)

    respond_to do |format|
      if @buy_bitcoin.save
        format.html { redirect_to @buy_bitcoin, notice: 'Buy bitcoin was successfully created.' }
        format.json { render :show, status: :created, location: @buy_bitcoin }
      else
        format.html { render :new }
        format.json { render json: @buy_bitcoin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /buy_bitcoins/1
  # PATCH/PUT /buy_bitcoins/1.json
  def update
    respond_to do |format|
      if @buy_bitcoin.update(buy_bitcoin_params)
        format.html { redirect_to @buy_bitcoin, notice: 'Buy bitcoin was successfully updated.' }
        format.json { render :show, status: :ok, location: @buy_bitcoin }
      else
        format.html { render :edit }
        format.json { render json: @buy_bitcoin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /buy_bitcoins/1
  # DELETE /buy_bitcoins/1.json
  def destroy
    @buy_bitcoin.destroy
    respond_to do |format|
      format.html { redirect_to buy_bitcoins_url, notice: 'Buy bitcoin was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_buy_bitcoin
      @buy_bitcoin = BuyBitcoin.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def buy_bitcoin_params
      params.require(:buy_bitcoin).permit(:name, :slug, :content)
    end
end
