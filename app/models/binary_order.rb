class BinaryOrder < ActiveRecord::Base
	validates :direction, presence: true
	#validate :premium, :has_funds

	# Mostly for use in Rake
	scope :lastday, -> { where(created_at: Date.yesterday.beginning_of_day..Date.yesterday.end_of_day) }
	scope :lastweek, -> { where(created_at: Date.yesterday.at_beginning_of_week.beginning_of_day..Date.yesterday.end_of_day) }
	scope :lastmonth, -> { where(created_at: Date.yesterday.at_beginning_of_month.beginning_of_day..Date.yesterday.end_of_day) }
	scope :lastyear, -> { where(created_at: Date.yesterday.at_beginning_of_year.beginning_of_day..Date.yesterday.end_of_day) }

  belongs_to :user
  belongs_to :binary_round


	enum direction: [:call, :put]
	enum ordertype: [:playbtc, :btcusd]

#	private

#		def has_funds
#			if user.balances.btc.last.amount < @binary_order.premium
#				errors.add(:premium, "Woah there buddy. Try depositing some more first!")
#			end
#		end


end
