class BinaryRound < ActiveRecord::Base
	scope :lastten, ->{ ended.where( created_at: 12.minutes.ago.utc..Time.now.utc )}
	scope :lasthour, ->{ ended.where( created_at: 62.minutes.ago.utc..Time.now.utc )}
	scope :lastday, ->{ ended.where( created_at: 1.day.ago.utc..Time.now.utc )}

	enum status: [:open, :started, :ended, :cancelled]
	enum itm: [:undecided, :call, :put]
  enum roundtype: [:btcusd60, :btcusd5, :btcusd60play]

	has_many :binary_orders
end
