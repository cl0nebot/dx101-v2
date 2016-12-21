class Dashboard::CryptoAddressesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_crypto_address, only: [:show, :edit, :update, :destroy]
  load_resource
  # GET /crypto_addresses
  # GET /crypto_addresses.json
  def index
    @crypto_addresses = CryptoAddress.all
  end

  # GET /crypto_addresses/1
  # GET /crypto_addresses/1.json
  def show
  end

  # GET /crypto_addresses/new
  def new
    @crypto_address = CryptoAddress.new
  end

  # GET /crypto_addresses/1/edit
  def edit
  end

  # POST /crypto_addresses
  # POST /crypto_addresses.json
  def create
    @crypto_address = CryptoAddress.new(crypto_address_params)
    @crypto_address.user_id = current_user.id
    @crypto_address.active = true
    @crypto_address.addrtype = 'wd'
    @crypto_address.currency = 'btc'


    respond_to do |format|
      if @crypto_address.save
        format.html { redirect_to dashboard_withdraw_path, notice: 'Address was successfully created.' }
        format.json { render :show, status: :created, location: @crypto_address }
      else
        format.html { render :new }
        format.json { render json: @crypto_address.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /crypto_addresses/1
  # PATCH/PUT /crypto_addresses/1.json
  def update
    respond_to do |format|
      if @crypto_address.update(crypto_address_params)
        format.html { redirect_to @crypto_address, notice: 'Crypto address was successfully updated.' }
        format.json { render :show, status: :ok, location: @crypto_address }
      else
        format.html { render :edit }
        format.json { render json: @crypto_address.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /crypto_addresses/1
  # DELETE /crypto_addresses/1.json
  def destroy
    @crypto_address.destroy
    respond_to do |format|
      format.html { redirect_to crypto_addresses_url, notice: 'Crypto address was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_crypto_address
      @crypto_address = CryptoAddress.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def crypto_address_params
      params.require(:crypto_address).permit(:address, :currency, :active, :addrtype, :user_id)
    end
end
