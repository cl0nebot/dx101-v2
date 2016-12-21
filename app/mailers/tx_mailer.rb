class TxMailer < ActionMailer::Base
  default from: "\"101 Digital Exchange\" <support@101.net>"

  def tx_received(uid,txid,amount)
  	@user = User.find(uid)
  	@txid = txid
  	@amount = amount
  	mail(to: @user.email, subject: '101: Incoming Transaction Received')
  end

  def tx_confirmed(uid,txid,amount)
  	@user = User.find(uid)
  	@txid = txid
  	@amount = amount
  	mail(to: @user.email, subject: '101: Incoming Transaction Confirmed')
  end

  def wd_sent
  end
end
