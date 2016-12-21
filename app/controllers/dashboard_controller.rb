class DashboardController < ApplicationController
	require 'rqrcode_png'
  
  before_action :authenticate_user!
  
  def index
    @now            = Time.now.strftime('%A %H:%M:%S')
    #@playbalance    = current_user.balances.playbtc.first_or_create(curtype: "play").amount
    @cbonusbalances = current_user.balances.cryptobonus
    @cryptobalances = current_user.balances.crypto
    @fiatbalances   = current_user.balances.fiat
    last            = ExtQuote.last
            @btcusd = last.val
        @btcusdtime = last.quotetime
  end

  def accept_tos
    @tosdate = current_user.tosdate.to_s
  end

  def tosupdate
    now = Time.now.utc
    @tosdate = current_user.update(tosdate: now)
    redirect_to dashboard_path, notice: 'Thank you for accepting the TOS.'  
  end

  def transactions
    #TODO: AJAXify this table
    @txes         = current_user.txes.order(created_at: :desc).last(200)
  end

  def btcdepaddress
    da = current_user.crypto_addresses.btc.dep.last
    @depaddr = da.address.to_s
    if @depaddr.empty?
      BitcoinWorker.perform_async(current_user.id)
    end
  end

  def deposit
    da = current_user.crypto_addresses.btc.dep.where(active:true).first_or_create(active:false)
    @depaddr = da.address.to_s
    
  	@qr           = RQRCode::QRCode.new(@depaddr).to_img.resize(200, 200).to_data_url
    @playaccount  = true if current_user.role == "play"
    @realbalances = current_user.balances[1..-1]
  end

  def withdraw
    @wdfee      = ENV['xbtwdfee'].to_f
    @maxwd      = [current_user.balances.btc.first.amount - @wdfee, 0].max
    @wdaddr     = current_user.crypto_addresses.btc.wd.where(active:true).last
    @wdreq      = Tx.new
    #@txtypes    = ['btc', 'ltc', 'dgc']
  end

  def wdreq
    @wdfee          = ENV['xbtwdfee'].to_f
    @wdreq          = Tx.new(wdreq_params)
    @wdreq.user_id  = current_user.id
    @wdreq.currency = 'btc'
    @wdreq.txtype   = 'withdrawal'
    @wdreq.status   = 'pending'
    @wdreq.address  = CryptoAddress.btc.wd.where(user_id: current_user.id, active: true).last.address

    if @wdreq.save
      tot = @wdreq.amount + @wdfee
      bal = Balance.btc.where(user_id: current_user.id).first
      newbal = bal.amount - tot
      newrestricted = bal.restricted.to_f + tot
      bal.update(amount: newbal, restricted: newrestricted)
      redirect_to dashboard_withdraw_path, notice: 'Withdraw Request order was successfully created.'  
    else
      redirect_to dashboard_withdraw_path
    end
  
  end
  
  private

    def tosupdate_params
      params.require(:tosdate)
    end

    def wdreq_params
      params.require(:tx).permit(:amount, :currency)
    end
end
