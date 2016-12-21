class BitcoinWorker
  include Sidekiq::Worker

  def perform(id)
    depaddr = Bitcoin(ENV['xbtuser'], ENV['xbtpass'], host: ENV['xbthost'], port: ENV['xbtport']).getnewaddress

		c = CryptoAddress.btc.dep.where(user_id: id, active: true)
		c.each do |disable|
			disable.update(active: false)
		end
    CryptoAddress.create(address: depaddr, currency: 'btc', active: true, addrtype: 'dep', user_id: id)
  end

end