class Dashboard::ReportsController < ApplicationController
before_filter :authenticate_user!
before_filter :market_open

	def index
		@housebalbtc = Balance.btc.find_by(user_id: 51)
		@housebalplaybtc = Balance.playbtc.find_by(user_id: 51)

		@seedbtc 				= Balance.btc.where("user_id IN (?)", User.seed.each).sum(:amount)
    @seedplay				= Balance.playbtc.where("user_id IN (?)", User.seed.each).sum(:amount)

		@usercount 			= User.user.count
		@playcount 			= User.play.count
		@seedcount 			= User.seed.count
		@disabledcount 	= User.disabled.count
		@admincount 		= User.admin.count

		@dbonus = BonusPool.daily.where("DATE(startday) = ?", Date.today).first.paid_in.to_f.round(8)
		@wbonus = BonusPool.weekly.where("DATE(startday) = ?", Date.today.beginning_of_week).first.paid_in.to_f.round(8)
		@mbonus = BonusPool.monthly.where("DATE(startday) = ?", Date.today.beginning_of_month).first.paid_in.to_f.round(8)
		@ybonus = BonusPool.yearly.where("DATE(startday) = ?", Date.today.beginning_of_year).first.paid_in.to_f.round(8)

		@paid_in = BonusPool.all.sum(:paid_in)
		@paid_out = BonusPool.all.sum(:paid_out)

		
		s1 = BinaryRound.started.btcusd60.first
		if s1.nil?
			@s1rnd = 0.0
		else
			@started1min = s1.id
			@s1rnd = BinaryOrder.where(binary_round_id: @started1min).sum(:premium).to_f
		end

		s5 = BinaryRound.started.btcusd5.first
		if s5.nil?
			@s5rnd = 0.0
		else
			@started5min = s5.id
			@s5rnd = BinaryOrder.where(binary_round_id: @started5min).sum(:premium).to_f
		end

		if market_open
			@open1min = BinaryRound.open.btcusd60.first.id
			@o1rnd = BinaryOrder.where(binary_round_id: @open1min).sum(:premium).to_f
			@open5min = BinaryRound.open.btcusd5.first.id
			@o5rnd = BinaryOrder.where(binary_round_id: @open5min).sum(:premium).to_f
			@inplay1 = @s1rnd + @o1rnd
		@inplay5 = @s5rnd + @o5rnd

		end	
		
		
		@onering = @housebalbtc.amount + @seedbtc + @paid_in + @inplay1.to_f + @inplay5.to_f

		con = Bitcoin(ENV['xbtuser'], ENV['xbtpass'], host: ENV['xbthost'], port: ENV['xbtport'])
		@hotbal = con.getbalance
	end
end

