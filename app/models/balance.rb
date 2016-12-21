class Balance < ActiveRecord::Base
  belongs_to :user

  enum currency: { playbtc: 0, btc: 1, usd: 2, btcbonus: 3 } 
  enum curtype:  { play: 0, crypto: 1, fiat: 2, cryptobonus: 3, fiatbonus: 4 }
end
