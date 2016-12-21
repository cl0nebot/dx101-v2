class NewaccountWorker
  include Sidekiq::Worker

  def perform(id)
  	
  	if Balance.playbtc.where(user_id: id).count == 0
    	Balance.create(currency: "playbtc", curtype: "play", amount: 1, user_id: id )
    end
    if Balance.btc.where(user_id: id).count == 0
    	Balance.create(currency: "btc", curtype: "crypto", amount: 0, user_id: id )
    end
  end

end