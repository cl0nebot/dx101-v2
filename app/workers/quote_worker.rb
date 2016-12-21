class QuoteWorker
	include Sidekiq::Worker
  include Sidetiq::Schedulable

	recurrence { minutely.second_of_minute(10,25,40,55) }
	

	def perform
		cdquote = JSON.parse(HTTParty.get('http://api.coindesk.com/v1/bpi/currentprice.json'))
		source = "CD"
		pair = "BTCUSD"
		value = cdquote["bpi"]["USD"]["rate_float"]
		quotetime = Time.parse cdquote["time"]["updated"]

		dupe = ExtQuote.where("source = 'CD' and pair = ? and quotetime = ?", 0, quotetime).count
		unless dupe > 0
			ExtQuote.create(source: source, pair: pair, val: value, quotetime: quotetime)
		end 
	end
end