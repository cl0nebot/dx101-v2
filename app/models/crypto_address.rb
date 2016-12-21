class CryptoAddress < ActiveRecord::Base
  belongs_to :user

  enum currency: [:btc, :ltc, :dgc]
  enum addrtype: [:dep, :wd]
end
