class CryptowithdrawWorker
	include Sidekiq::Worker
  include Sidetiq::Schedulable

	recurrence { hourly.minute_of_hour(0, 10, 20, 30, 40, 50) }

	def perform
		con = Bitcoin(ENV['xbtuser'], ENV['xbtpass'], host: ENV['xbthost'], port: ENV['xbtport'])
		Tx.withdrawal.pending.btc.each do |t|

			b = Balance.btc.where(user_id: t.user_id).first
			rbal = b.restricted
			abal = b.amount
			wdtot = t.amount + 0.0002
	
			# Another idea - limit withdrawals to once per hour?
			#tests
			if (abal < 0  || rbal < wdtot)
				t.cancelled!
				# Stop fucking with us!
				#TxMailer.tx_exception(t.user_id, t.amount).deliver
				#User.where(user_id: ).disabled!
			else
				#avail = con.getbalance # check balance before?
				txid 	= con.sendtoaddress(t.address, t.amount.to_f)
				gettx = con.gettransaction(txid)
				rawtx = con.decoderawtransaction(gettx['hex'])
				vin 	= rawtx['vin'][0]['txid']
				t.update(txid: txid, status: "unconfirmed", confirmations: gettx['confirmations'], vin: vin)
				rbal -= t.amount
				b.update(restricted: rbal)
				# Add a field for 
				#TxMailer.tx_withdrawal(t.user_id, t.amount).deliver
			end
		end

		Tx.withdrawal.unconfirmed.btc.each do |t|
			txconf = con.gettransaction(t.txid)['confirmations']
			if txconf > 2
				now = Time.now
				t.update(confirmations: txconf, status: "complete", complete_at: now)
			else
				t.update(confirmations: txconf)
			end
		end
	end
end
	 		



=begin
		Tx.unconfirmed.each do |t|
			con = Bitcoin(ENV['xbtuser'], ENV['xbtpass'], host: ENV['xbthost'], port: ENV['xbtport'])
	 		txinfo = con.gettransaction t.txid
			confirms = txinfo["confirmations"]	 
		#update # of confirmations
			t.update confirmations: confirms
		#if # of confirmations > 3, set confirmed, update balances.
			if confirms > 2 
				t.update status: "complete"
				ubal = Balance.where(user_id: t.user_id, currency: 1).last ###FIX ENUM# 
				ubalid = ubal.id
				rbal = ubal.restricted.to_d - txinfo["amount"]
				bal = ubal.amount.to_d + txinfo["amount"]
				Balance.update(ubalid, restricted: rbal, amount: bal)
				TxMailer.tx_confirmed(t.user_id, t.txid, txinfo["amount"]).deliver

			end
		end

	end
=end