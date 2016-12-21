class BinaryOrdersController < ApplicationController
  before_action :set_binary_order, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  load_and_authorize_resource

  # GET /binary_orders
  # GET /binary_orders.json
  def index
    if market_open
      @open1round       = BinaryRound.open.btcusd60.first
      @open5round       = BinaryRound.open.btcusd5.first
      @active1round     = BinaryRound.started.btcusd60.first
      @active5round     = BinaryRound.started.btcusd5.first
    end

    

    @binary_order   = BinaryOrder.new
    @maxprem        = Balance.btc.where(user_id: current_user.id).first_or_create(curtype: "crypto").amount.to_f

    #For the 1 minute tab
    @last101mincall = BinaryRound.btcusd60.lastten.call.count
    @last101minput = BinaryRound.btcusd60.lastten.put.count
    @lasthour1mincall = BinaryRound.btcusd60.lasthour.call.count
    @lasthour1minput = BinaryRound.btcusd60.lasthour.put.count
    @lastday1mincall = BinaryRound.btcusd60.lastday.call.count
    @lastday1minput = BinaryRound.btcusd60.lastday.put.count

    @open1 = current_user.binary_orders.where(binary_round_id: @open1round).order(id: :desc) 
    @active1 = current_user.binary_orders.where(binary_round_id: @active1round).order(id: :desc) 
    #For the 5 minute tab
    @open5 = current_user.binary_orders.where(binary_round_id: @open5round).order(id: :desc) 
    @active5 = current_user.binary_orders.where(binary_round_id: @active5round).order(id: :desc) 
    #For the Transactions Tab
    @open_orders    = current_user.binary_orders.where(binary_round_id: [@open1round,@open5round]).order(id: :desc) 
    @active_orders  = current_user.binary_orders.where(binary_round_id: BinaryRound.started).order(id: :desc)
    @closed_orders  = current_user.binary_orders.where(binary_round_id: BinaryRound.ended).order(id: :desc)
  end

  def history
    @binary_order   = BinaryOrder.new
    @maxprem        = Balance.btc.where(user_id: current_user.id).first_or_create.amount.to_f
    @open_orders    = current_user.binary_orders.where(binary_round_id: openround)

    @active_orders  = BinaryOrder.where(user_id: current_user.id, binary_round_id: activeround)
    @closed_orders  = BinaryOrder.where("user_id = ? AND binary_round_id < ?", current_user.id,activeround)

  end
  # GET /binary_orders/1
  # GET /binary_orders/1.json
  def show
  end

  # GET /binary_orders/new
  def new
    @binary_order = BinaryOrder.new
    @maxprem      = Balance.btc.where(user_id: current_user.id).first_or_create.amount.to_f
    #@maxplayprem  = Balance.playbtc.where(user_id: current_user.id).first.amount
    ###
  end

  # GET /binary_orders/1/edit
  def edit
    @maxprem = Balance.btc.where(user_id: current_user.id).first.amount
  end

  # POST /binary_orders
  # POST /binary_orders.json
  def create
    @binary_order = BinaryOrder.new(binary_order_params)
    if params[:commit] == 'CALL'
      @binary_order.direction = 'call'
    elsif params[:commit] == 'PUT'
      @binary_order.direction = 'put'
    end
    @binary_order.user_id = current_user.id
    @binary_order.binary_round_id = BinaryRound.open.find_by(roundtype: params[:roundtype].to_i).id

    #if current_user.role == "play"
    #  @binary_order.ordertype = "playbtc"
    #  bal = current_user.balances.playbtc.last.amount
    #  current_user.balances.playbtc.last.update(amount: (bal - @binary_order.premium))
    #else
      @binary_order.ordertype = "btcusd" 
      bal = current_user.balances.crypto.btc.first.amount.to_f
      current_user.balances.crypto.btc.first.update(amount: (bal - @binary_order.premium))
    #end


    respond_to do |format|
      if @binary_order.save
        format.html { redirect_to binary_orders_path, notice: 'Binary order was successfully created.' }
        format.json { render :show, status: :created, location: @binary_order }
      else
        format.html { redirect_to binary_orders_path, notice: 'Try again.' }
        format.json { render json: @binary_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /binary_orders/1
  # PATCH/PUT /binary_orders/1.json
  def update
    respond_to do |format|
      if @binary_order.update(binary_order_params)
        format.html { redirect_to @binary_order, notice: 'Binary order was successfully updated.' }
        format.json { render :show, status: :ok, location: @binary_order }
      else
        format.html { render :edit }
        format.json { render json: @binary_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /binary_orders/1
  # DELETE /binary_orders/1.json
  def destroy
    @binary_order.destroy
    respond_to do |format|
      format.html { redirect_to binary_orders_url, notice: 'Binary order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_binary_order
      @binary_order = BinaryOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def binary_order_params
      params.require(:binary_order).permit(:user_id, :order, :premium, :roundtype)
    end
end
