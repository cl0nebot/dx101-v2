class HomepageController < ApplicationController
  def index

  last = ExtQuote.last
  @btcusd = last.val
  @btcusdtime = last.quotetime

=begin
	if request.env['affiliate.tag'] && AffCode.find_by(code: request.env['affiliate.tag'])
		@refid = request.env['affiliate.tag']
	else
		@refid = "house"
	end
=end
  end

  def leaderboard
  	# Active / Current Pools have no payouts
		dpoolactive = BonusPool.daily.find_by(startday: Time.now.utc.beginning_of_day)
    dpoolactive.nil? ? @dbonus = 0 : @dbonus = dpoolactive.paid_in.round(8)

		wpoolactive = BonusPool.weekly.find_by(startday: Time.now.utc.beginning_of_week)
    wpoolactive.nil? ? @wbonus = 0 : @wbonus = wpoolactive.paid_in.round(8)

		mpoolactive = BonusPool.monthly.find_by(startday: Time.now.utc.beginning_of_month)
    mpoolactive.nil? ? @mbonus = 0 : @mbonus = mpoolactive.paid_in.round(8)

		ypoolactive = BonusPool.yearly.find_by(startday: Time.now.utc.beginning_of_year)
    ypoolactive.nil? ? @ybonus = 0 : @ybonus = ypoolactive.paid_in.round(8)


  	# All but current pools
  	@dailypools  = BonusPool.daily.where.not(startday: Time.now.utc.beginning_of_day).order(startday: :desc)
  	@weeklypools = BonusPool.weekly.where.not(startday: Time.now.utc.beginning_of_week).order(startday: :desc)
  	@monthlypools = BonusPool.monthly.where.not(startday: Time.now.utc.beginning_of_month).order(startday: :desc)
  	@yearlypools = BonusPool.yearly.where.not(startday: Time.now.utc.beginning_of_year).order(startday: :desc)


    last = ExtQuote.last
    @btcusd = last.val
    @btcusdtime = last.quotetime
  end

  def pools
    @pool = BonusPool.find(params[:id])
    case @pool.bonustype
    when "daily" 
      @pars = Par.where("bonus_pools_id = ? AND rank < ?", params[:id], 4).order(:rank)
    when "weekly"
      @pars = Par.where("bonus_pools_id = ? AND rank < ?", params[:id], 6).order(:rank)
    when "monthly"
      @pars = Par.where("bonus_pools_id = ? AND rank < ?", params[:id], 11).order(:rank)
    else   #yearly
      @pars = Par.where("bonus_pools_id = ? AND rank < ?", params[:id], 51).order(:rank)
    end
    
    last = ExtQuote.last
    @btcusd = last.val
    @btcusdtime = last.quotetime
  end
end
