namespace :pools do
# see scopes a/m/b_o /b_r for lastX

	desc "Calculate and Pay Pools"

	task :daily => :environment do
		desc "Process Daily Pool"
		
		poolid = BonusPool.daily.where(startday: Date.yesterday.beginning_of_day).first_or_create.id
		BinaryOrder.where("DATE(created_at) = ?", Date.yesterday).select(:user_id).distinct.each do |u|
			rounds = BinaryOrder.where("DATE(created_at) = ? AND user_id = ?", Date.yesterday, u.user_id).count
			premiums = BinaryOrder.where("DATE(created_at) = ? AND user_id = ?", Date.yesterday, u.user_id).sum(:premium)
			wins = BinaryOrder.where("DATE(created_at) = ? AND user_id = ? AND itm = ?", Date.yesterday, u.user_id, true).count
      losses = BinaryOrder.where("DATE(created_at) = ? AND user_id = ? AND itm = ?", Date.yesterday, u.user_id, false).count
      activerounds = wins + losses
      accuracy = (wins.to_f / activerounds.to_f)
			Par.create(
				user_id: u.user_id,
				date: Date.yesterday,
				rounds: rounds,
				activerounds: activerounds,
				premiums: premiums,
				wins: wins,
				losses: losses,
				accuracy: accuracy,
				period: "day",
				bonus_pools_id: poolid
				)
		end

		n = Par.day.where(date: Date.yesterday.beginning_of_day).count
		decby = 100/n.to_f
		
		percentile = 100.0
		Par.where("DATE(date) = ?", Date.yesterday).order(premiums: :desc).each do |p|
			p.update(p_percentile: percentile)
			percentile -= decby
		end

		percentile = 100.0
		Par.where("DATE(date) = ?", Date.yesterday).order(accuracy: :desc).each do |a|
			a.update(a_percentile: percentile)
			percentile -= decby
		end

		percentile = 100.0
		Par.where("DATE(date) = ?", Date.yesterday).order(rounds: :desc).each do |r|
			score = r.p_percentile * r.a_percentile * percentile
			r.update(r_percentile: percentile, score: score)
			percentile -= decby
		end

		# rank them
		rank = 1
		Par.where("DATE(date) = ?", Date.yesterday).order(score: :desc).each do |p|
			p.update(rank: rank)
			rank += 1
		end

		# pay them
		bpool = BonusPool.daily.where("DATE(startday) = ?", Date.yesterday).first_or_create(startday: Date.yesterday)
		paid_in = bpool.paid_in.to_f
		
		paymatrix = [0.5, 0.3, 0.2]
		players = Par.day.where(date: Date.yesterday.beginning_of_day).count
		# not enough players? 
		paymatrix = paymatrix[0..[paymatrix.size,players].min-1]

		paymatrix.each_with_index do |w, i|
			winnerpar = Par.day.find_by(date: Date.yesterday.beginning_of_day, rank: i+1)
			payout = paid_in * w
			winnerpar.update(payout: payout)
			bpool.update(paid_out: bpool.paid_out.to_f + payout)
			winner = User.find(winnerpar.user_id).balances.btc.first
			winner.update(amount: winner.amount.to_f + payout)
			Tx.create( txtype: "winpool", amount: payout, currency: "btc", user_id: winnerpar.user_id, txid: bpool.id, status: "complete", complete_at: Time.now )
		end
		# got leftovers? 
		if paymatrix.sum < 1
			#TODO Pay System Account wiht leftovers
		end

	end

# TODO: weekly PAR Calcs and Payouts
# TODO: ensure this gets only run every Sunday morning. Once.
	task :weekly => :environment do
		desc "Process Weekly Pool"

		if Time.now.sunday? == false
			puts "not Sunday. Try later"
			exit
		end
		poolid = BonusPool.weekly.where(startday: Date.yesterday.beginning_of_week).first_or_create.id
		BinaryOrder.lastweek.select(:user_id).distinct.each do |u|
			rounds 		= BinaryOrder.lastweek.where(user_id: u.user_id).count
			premiums 	= BinaryOrder.lastweek.where(user_id: u.user_id).sum(:premium)
			wins 			= BinaryOrder.lastweek.where(user_id: u.user_id, itm: true).count
      losses		= BinaryOrder.lastweek.where(user_id: u.user_id, itm: false).count
      activerounds = wins + losses
      accuracy 	= (wins.to_f / activerounds.to_f)
			Par.create(
				user_id: u.user_id,
				date: Date.yesterday,
				rounds: rounds,
				activerounds: activerounds,
				premiums: premiums,
				wins: wins,
				losses: losses,
				accuracy: accuracy,
				period: "week",
				bonus_pools_id: poolid
				)
		end


		n = Par.week.where(date: Date.yesterday.beginning_of_day).count
		decby = 100/n.to_f
		
		percentile = 100.0
		Par.week.where(date: Date.yesterday.beginning_of_day).order(premiums: :desc).each do |p|
			p.update(p_percentile: percentile)
			percentile -= decby
		end

		percentile = 100.0
		Par.week.where(date: Date.yesterday.beginning_of_day).order(accuracy: :desc).each do |a|
			a.update(a_percentile: percentile)
			percentile -= decby
		end

		percentile = 100.0
		Par.week.where(date: Date.yesterday.beginning_of_day).order(rounds: :desc).each do |r|
			score = r.p_percentile * r.a_percentile * percentile
			r.update(r_percentile: percentile, score: score)
			percentile -= decby
		end

		# rank them
		rank = 1
		Par.week.where(date: Date.yesterday.beginning_of_day).order(score: :desc).each do |p|
			p.update(rank: rank)
			rank += 1
		end

		# pay them
		bpool = BonusPool.weekly.where("DATE(startday) = ?", Date.yesterday).first_or_create(startday: Date.yesterday)
		paid_in = bpool.paid_in.to_f
		paymatrix = [0.4, 0.24, 0.16, 0.12, 0.08]
		players = Par.week.where(date: Date.yesterday.beginning_of_day).count
		# not enough players? 
		paymatrix = paymatrix[0..[paymatrix.size,players].min-1]

		paymatrix.each_with_index do |w, i|
			winnerpar = Par.week.find_by(date: Date.yesterday.beginning_of_day, rank: i+1)
			payout = paid_in * w
			winnerpar.update(payout: payout)
			bpool.update(paid_out: bpool.paid_out.to_f + payout)
			winner = User.find(winnerpar.user_id).balances.btc.first
			winner.update(amount: winner.amount.to_f + payout)
			Tx.create( txtype: "winpool", amount: payout, currency: "btc", user_id: winnerpar.user_id, txid: bpool.id, status: "complete", complete_at: Time.now )
		end
		# got leftovers? 
		if paymatrix.sum < 1
			#TODO Pay System Account wiht leftovers
		end

	end

	task :monthly => :environment do
		desc "Process Monthy Pool"

		poolid = BonusPool.monthly.where(startday: Date.yesterday.beginning_of_month).first_or_create.id
		BinaryOrder.lastmonth.select(:user_id).distinct.each do |u|
			rounds 		= BinaryOrder.lastmonth.where(user_id: u.user_id).count
			premiums 	= BinaryOrder.lastmonth.where(user_id: u.user_id).sum(:premium)
			wins 			= BinaryOrder.lastmonth.where(user_id: u.user_id, itm: true).count
      losses		= BinaryOrder.lastmonth.where(user_id: u.user_id, itm: false).count
      activerounds = wins + losses
      accuracy 	= (wins.to_f / activerounds.to_f)
			Par.create(
				user_id: u.user_id,
				date: Date.yesterday,
				rounds: rounds,
				activerounds: activerounds,
				premiums: premiums,
				wins: wins,
				losses: losses,
				accuracy: accuracy,
				period: "month",
				bonus_pools_id: poolid
				)
		end


		n = Par.month.where(date: Date.yesterday.beginning_of_day).count
		decby = 100/n.to_f
		
		percentile = 100.0
		Par.month.where(date: Date.yesterday.beginning_of_day).order(premiums: :desc).each do |p|
			p.update(p_percentile: percentile)
			percentile -= decby
		end

		percentile = 100.0
		Par.month.where(date: Date.yesterday.beginning_of_day).order(accuracy: :desc).each do |a|
			a.update(a_percentile: percentile)
			percentile -= decby
		end

		percentile = 100.0
		Par.month.where(date: Date.yesterday.beginning_of_day).order(rounds: :desc).each do |r|
			score = r.p_percentile * r.a_percentile * percentile
			r.update(r_percentile: percentile, score: score)
			percentile -= decby
		end

		# rank them
		rank = 1
		Par.month.where(date: Date.yesterday.beginning_of_day).order(score: :desc).each do |p|
			p.update(rank: rank)
			rank += 1
		end

		# pay them
		bpool = BonusPool.monthly.where("DATE(startday) = ?", Date.yesterday).first_or_create(startday: Date.yesterday)
		paid_in = bpool.paid_in.to_f
		paymatrix = [0.3, 0.2, 0.12, 0.0925, 0.075, 0.0625, 0.0525, 0.0425, 0.0325, 0.0225]
		players = Par.month.where(date: Date.yesterday.beginning_of_day).count
		# not enough players? 
		paymatrix = paymatrix[0..[paymatrix.size,players].min-1]

		paymatrix.each_with_index do |w, i|
			winnerpar = Par.month.find_by(date: Date.yesterday.beginning_of_day, rank: i+1)
			payout = paid_in * w
			winnerpar.update(payout: payout)
			bpool.update(paid_out: bpool.paid_out.to_f + payout)
			winner = User.find(winnerpar.user_id).balances.btc.first
			winner.update(amount: winner.amount.to_f + payout)
			Tx.create( txtype: "winpool", amount: payout, currency: "btc", user_id: winnerpar.user_id, txid: bpool.id, status: "complete", complete_at: Time.now )
		end
		# got leftovers? 
		if paymatrix.sum < 1
			#TODO Pay System Account wiht leftovers
		end
	end

	task :yearly => :environment do
		desc "Process Yearly Pool"
		poolid = BonusPool.yearly.where(startday: Date.yesterday.beginning_of_year).first_or_create.id
		BinaryOrder.lastyear.select(:user_id).distinct.each do |u|
			rounds 		= BinaryOrder.lastyear.where(user_id: u.user_id).count
			premiums 	= BinaryOrder.lastyear.where(user_id: u.user_id).sum(:premium)
			wins 			= BinaryOrder.lastyear.where(user_id: u.user_id, itm: true).count
      losses		= BinaryOrder.lastyear.where(user_id: u.user_id, itm: false).count
      activerounds = wins + losses
      accuracy 	= (wins.to_f / activerounds.to_f)
			Par.create(
				user_id: u.user_id,
				date: Date.yesterday,
				rounds: rounds,
				activerounds: activerounds,
				premiums: premiums,
				wins: wins,
				losses: losses,
				accuracy: accuracy,
				period: "year",
				bonus_pools_id: poolid
				)
		end

		n = Par.year.where(date: Date.yesterday.beginning_of_day).count
		decby = 100/n.to_f
		
		percentile = 100.0
		Par.year.where(date: Date.yesterday.beginning_of_day).order(premiums: :desc).each do |p|
			p.update(p_percentile: percentile)
			percentile -= decby
		end

		percentile = 100.0
		Par.year.where(date: Date.yesterday.beginning_of_day).order(accuracy: :desc).each do |a|
			a.update(a_percentile: percentile)
			percentile -= decby
		end

		percentile = 100.0
		Par.year.where(date: Date.yesterday.beginning_of_day).order(rounds: :desc).each do |r|
			score = r.p_percentile * r.a_percentile * percentile
			r.update(r_percentile: percentile, score: score)
			percentile -= decby
		end

		# rank them
		rank = 1
		Par.year.where(date: Date.yesterday.beginning_of_day).order(score: :desc).each do |p|
			p.update(rank: rank)
			rank += 1
		end

		bpool = BonusPool.yearly.where("DATE(startday) = ?", Date.yesterday).first_or_create(startday: Date.yesterday)
		paid_in = bpool.paid_in.to_f
		paymatrix = [0.25, 0.15, 0.1, 0.075, 0.065, 0.055, 0.045, 0.03, 0.0175, 0.0125, 0.0095, 0.0095, 0.0095, 0.0095, 0.0095, 0.0075, 0.0075, 0.0075, 0.0075, 0.0075, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.005, 0.0035, 0.0035, 0.0035, 0.0035, 0.0035, 0.0035, 0.0035, 0.0035, 0.0035, 0.0035, 0.003, 0.003, 0.003, 0.003, 0.003, 0.003, 0.003, 0.003, 0.003, 0.003]
		players = Par.year.where(date: Date.yesterday.beginning_of_day).count
		# not enough players? 
		paymatrix = paymatrix[0..[paymatrix.size,players].min-1]

		paymatrix.each_with_index do |w, i|
			winnerpar = Par.year.find_by(date: Date.yesterday.beginning_of_day, rank: i+1)
			payout = paid_in * w
			winnerpar.update(payout: payout)
			bpool.update(paid_out: bpool.paid_out.to_f + payout)
			winner = User.find(winnerpar.user_id).balances.btc.first
			winner.update(amount: winner.amount.to_f + payout)
			Tx.create( txtype: "winpool", amount: payout, currency: "btc", user_id: winnerpar.user_id, txid: bpool.id, status: "complete", complete_at: Time.now )
		end
		# got leftovers? 
		if paymatrix.sum < 1
			#TODO Pay System Account wiht leftovers
		end
	end

end