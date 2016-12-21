class CryptodepositWorker
	include Sidekiq::Worker
  include Sidetiq::Schedulable

	recurrence { minutely(10) }

	def perform
		#find transactions which are pending
		Tx.unconfirmed.each do |t|
			con = Bitcoin(ENV['xbtuser'], ENV['xbtpass'], host: ENV['xbthost'], port: ENV['xbtport'])
	 		txinfo = con.gettransaction t.txid
			confirms = txinfo["confirmations"]	 
		
			t.update confirmations: confirms
		
			if confirms > 2 
				t.update status: "complete"
				u = User.find(t.user_id)
				ubal = u.balances.btc.first
				ubalid = ubal.id
				rbal = ubal.restricted.to_d - txinfo["amount"]
				bal = ubal.amount.to_d + txinfo["amount"]
				Balance.update(ubalid, restricted: rbal, amount: bal)
								
				if u.txes.deposit.btc.count == 1
					u.balances.btcbonus.first_or_create.update(amount: txinfo["amount"])
					# change this to reflect deposit bonus
					TxMailer.tx_confirmed(t.user_id, t.txid, txinfo["amount"]).deliver
				else
					TxMailer.tx_confirmed(t.user_id, t.txid, txinfo["amount"]).deliver
				end
			end
		end

	end
end