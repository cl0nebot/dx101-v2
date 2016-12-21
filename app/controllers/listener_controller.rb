class ListenerController < ActionController::Base

#  force_ssl
#  before_action :auth_required

  def deposit
    if params[:currency] and params[:txid]
    	unless Tx.where(txid: params[:txid]).length > 0 #unless we already have it
	    	con = Bitcoin(ENV['xbtuser'], ENV['xbtpass'], host: ENV['xbthost'], port: ENV['xbtport'])
	    	txinfo = con.gettransaction params[:txid]
	    	if txinfo["details"][0]["category"] == "receive"
					addr = txinfo["details"][0]["address"]
					user = CryptoAddress.find_by(address: addr).user_id
					Tx.create(
						txtype: "deposit",
						currency: "btc",
						status: "unconfirmed",
						amount: txinfo["amount"],
						confirmations: txinfo["confirmations"],
						address: addr,
						user_id: user,
						txid: params[:txid]
						)
					ubal = Balance.where(user_id: user, currency: 1).last ###FIX ENUM
					ubalid = ubal.id
					rbal = ubal.restricted.to_f + txinfo["amount"]
					Balance.update(ubalid, restricted: rbal)
					TxMailer.tx_received(user, params[:txid], txinfo["amount"]).deliver
				end
			end
      render status: 200, nothing: true
    else
      render status: 500, nothing: true
    end
  end
end