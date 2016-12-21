task :rotate => :environment do

# Get these back into the helper file!  
# Beware of poluted scopes... see http://stackoverflow.com/questions/1450112/how-do-i-use-helpers-in-rake

	def market_open
		hr = Time.now.utc.strftime("%H").to_i
		hr.between?(16,23)
	end

	def happy_hour
		#hr = Time.now.utc.strftime("%H").to_i
		#hr == 23
		true
	end

	btcval = ExtQuote.last.val.to_f

	puts "\n------------------------\n"
	puts Time.now.utc
	puts "Market Open?\t#{market_open}"
	puts "Happy Hour?\t#{happy_hour}"
	puts "------------------------\n\n"
	
	# Close Started Rounds
	BinaryRound.started.where("endtime < ?", Time.now.utc).each do |r|
		puts "Closing Round\t#{r.id}"

		#Balance.currencies enum  - more useful when we add more currencies
		#REFACTOR: Using this twice -= make it a function
		case r.roundtype
		when "btcusd60play" 
			cur = "playbtc"
			curid = 0
		else
			cur = "btc"
			curid = 1
		end

		openval = r.open.to_f
		
		r.close = btcval

		if r.open == r.close
			
			puts "Round Undecided - Starting price matches Ending price"

			r.status = "cancelled"
			r.itm = "undecided"
			r.save

			BinaryOrder.where(binary_round_id: r.id).each do |o|
				o.update(itmpayout: o.premium)

				Tx.create(
					txtype: "selloption",
					amount: o.premium,
					currency: cur,
					user_id: o.user_id,
					txid: o.id,
					status: "complete"
					)
				bal = Balance.btc.where(user_id: o.user_id).first_or_create
				balamt = bal.amount.to_f
				balamt += o.premium
				bal.update(amount: balamt)
			end

		else		# round had a winning side, good to process
			r.status = "ended"
			r.open.to_f > btcval ? r.itm = "put" : r.itm = "call"
			puts "Start:\t\t#{r.open}"
			puts "End:\t\t#{btcval}"
			puts "Result:\t\t#{r.itm}"

			# Step 1: Collect Premiums
			BinaryOrder.where(binary_round_id: r.id).each do |o|
				puts "Order: #{o.id}\t#{o.premium}\t#{o.direction}"
				# set up the balanace account
				o.prembalance = o.premium
				#credit pool
				pool = o.premium * 0.9
				o.prembalance -= pool
				o.pool = pool
				#credit system bonus pools - all in one for now
				sysbonus = o.premium * 0.04
				o.prembalance -= sysbonus
				o.sysbonus = sysbonus
				
				daybonus 		= o.premium * 0.02
				dbonus = BonusPool.daily.where("DATE(startday) = ?", Date.today).first_or_create(startday: Date.today)
				dbonus.update(paid_in: dbonus.paid_in.to_f + daybonus)
				weekbonus 	= o.premium * 0.01
				wbonus = BonusPool.weekly.where("DATE(startday) = ?", Date.today.beginning_of_week).first_or_create(startday: Date.today.beginning_of_week)
				wbonus.update(paid_in: wbonus.paid_in.to_f + weekbonus)
				monthbonus 	= o.premium * 0.0085
				mbonus = BonusPool.monthly.where("DATE(startday) = ?", Date.today.beginning_of_month).first_or_create(startday: Date.today.beginning_of_month)
				mbonus.update(paid_in: mbonus.paid_in.to_f + monthbonus)
				yearbonus 	= o.premium * 0.0015
				ybonus = BonusPool.yearly.where("DATE(startday) = ?", Date.today.beginning_of_year).first_or_create(startday: Date.today.beginning_of_year)
				ybonus.update(paid_in: ybonus.paid_in.to_f + yearbonus)

				#dont do other calcs for play rounds
				unless cur == "playbtc"
					#credit deposit bonus - need to check if user qualifies first!
					cu = User.find(o.user_id)
					bonusacct = cu.balances.cryptobonus.find_or_create_by(currency: curid)

					bonus_target = bonusacct.amount.to_f
					bonus_earned = bonusacct.restricted.to_f

					if bonus_target > bonus_earned
						earnable 			= bonus_target - bonus_earned
						depbonus 			= [o.premium * 0.015, earnable].min
						o.prembalance -= depbonus
						o.depbonus 		= depbonus
						bonus_earned 	+= depbonus
						bonusacct.update(restricted: bonus_earned)
					end

					#credit affiliate 25% of profit
					ref = cu.refid
					unless ref.nil?
						affpay = o.prembalance * 0.25
						o.prembalance -= affpay
						o.affpay = affpay
						affiliate = AffCode.find_by(code: ref).user_id
						Tx.create(
							txtype: "afffee",
							amount: affpay,
							currency: cur,
							user_id: affiliate,
							txid: r.id,
							status: "complete"
							)
						bal = Balance.btc.where(user_id: affiliate).first_or_create(curtype: "crypto")
						bal.update(amount: bal.amount.to_f + affpay)
					end
				end

				r.itm == o.direction ? o.itm = true : o.itm = false
				o.profit = o.prembalance
				o.prembalance = 0
				o.save
				
				sysaccount = AffCode.find_by(code: "sys").user_id
				Tx.create(txtype: "sysprofit", amount: o.profit, currency: cur, user_id: sysaccount, txid: o.id, status: "complete")
				bal = Balance.where("user_id = ? and currency = ?", sysaccount, Balance.currencies[cur]).first
				bal.update(amount: bal.amount.to_f + o.profit)
				puts "System Profit\t#{o.profit}"

			end

			#Step 2: Figure out how much to pay ITM Premiums

			r.callsum = BinaryOrder.call.where(binary_round_id: r.id).sum(:premium)
			r.putsum 	= BinaryOrder.put.where(binary_round_id: r.id).sum(:premium)
			r.pool_in = BinaryOrder.where(binary_round_id: r.id).sum(:pool)
			# TODO: payratio giving infinity for some reason.
			# round 74 on production
			# itm=call / 0 call orders.  
			# This shouldn't happen as unbalance checker will kill the round or balance it.
			r.itm == "call" ? r.payratio = [(r.pool_in / r.callsum ),99].min : r.payratio = [(r.pool_in / r.putsum ),99].min
			r.save
			puts "------------------------"
			puts "Pool Payout Total: #{r.pool_in}"
			puts "------------------------"

			# Step 3: Pay Winners
			BinaryOrder.where("binary_round_id = ? AND direction = ?", r.id, BinaryOrder.directions[r.itm]).each do |w|
				payout = (w.premium * r.payratio).round(8)
				puts "Paying Option Owner #{w.user_id}: Premium #{w.premium} * #{r.payratio} in #{cur}"
				Tx.create(
					txtype: "selloption",
					amount: payout,
					currency: cur,
					user_id: w.user_id,
					txid: r.id,
					status: "complete"
					)
				bal = Balance.where("user_id = ? and currency = ?", w.user_id, Balance.currencies[cur]).first_or_create
				balamt = bal.amount.to_f + payout
				bal.update(amount: balamt)
				w.update(itmpayout: payout, itm: true)
				poolout = r.pool_out.to_f + payout
				r.update(pool_out: poolout)
			end
		end
	end

	# Start Open Rounds 
	BinaryRound.open.where("starttime < ?", Time.now.utc).each do |r|
		callsum 	= BinaryOrder.call.where(binary_round_id: r.id).sum(:premium)
		putsum 		= BinaryOrder.put.where(binary_round_id: r.id).sum(:premium)
		callcount = BinaryOrder.call.where(binary_round_id: r.id).count
		putcount 	= BinaryOrder.put.where(binary_round_id: r.id).count
		puts "------------------------"
		puts "Starting #{r.roundtype} Round\t#{r.id}"
		puts "Sum of Calls:\t#{callsum}"
		puts "Sum of Puts:\t#{putsum}"

		a = [callsum,putsum].max.to_f
		b = [callsum,putsum].min.to_f
		a/b < 6.67 ? balanced = true : balanced = false

		# Cancel if no orders
		if callcount + putcount == 0
			puts "no bets - cancelling"
			r.status = "cancelled"
		# Is the round balanced?
		elsif !balanced
			if happy_hour || r.roundtype == "btcusd60play"
				puts "Happy Hour Balancer!"

				case r.roundtype
				when "btcusd60play" 
					cur = "playbtc"
					ot = "playbtc"
				else
					cur = "btc"
					ot  = "btcusd"
				end

				houseplayer = AffCode.find_by(code: "house").user_id
				#amount to make up
				c = a / (20.0/3.0) # min and max of call / put from above
				makeup = ((c - b) * 100000000).round / 100000000.0 
				callsum > putsum ? direction = "put" : direction = "call"
				bo = BinaryOrder.create(user_id: houseplayer, binary_round_id: r.id, ordertype: ot, direction: direction, premium: makeup)
				Tx.create(txtype: "buyoption", amount: makeup, currency: cur, user_id: houseplayer, txid: bo.id, status: "complete")
				bal = Balance.where("user_id = ? and currency = ?", houseplayer, Balance.currencies[cur]).first_or_create(curtype: "crypto")

				bal.update(amount: bal.amount.to_f - makeup)
				puts "House Buys #{makeup} #{direction} to balance the round"
				r.status = "started"
			else 
				puts "Round Unbalanced - Cancelling"
				BinaryOrder.where(binary_round_id: r.id).each do |bo|
					Tx.create(txtype: "selloption", amount: bo.premium, currency: "btc", user_id: bo_user.id, txid: bo.id, status: "complete")
					bal = Balance.btc.find_by(user_id: bo.user_id)
					bal.update(amount: bal.amount + bo.premium)
				end
				r.status = "cancelled"
			end
		else
			r.status = "started"			
		end
		r.open = btcval
		r.save
	end

	
	if market_open

		# Open a New btcusd60 Round 
		newround = BinaryRound.new do |nr|
			nr.open!
			nr.btcusd60!
			nr.starttime = Time.now.utc.beginning_of_minute + 1.minute
			nr.endtime = Time.now.utc.beginning_of_minute + 2.minutes
			nr.save	
			puts "------------------------"
			puts "Opened #{nr.id}\tType:\t#{nr.roundtype}"
	
			fakeorders = rand(40)+1
			puts "#{fakeorders} orders for this round"
			players = User.seed.sample(fakeorders)
			players.each do |p|
				putcall = [*0..1].sample
				putcall == 0 ? dir = "call" : dir = "put"
				prem = rand(1..100)/10000.to_f
				bo = BinaryOrder.create(user_id: p.id, binary_round_id: nr.id, ordertype: "btcusd", direction: putcall, premium: prem)
				Tx.create(txtype: "buyoption", amount: prem, currency: "btc", user_id: p.id, txid: bo.id, status: "complete")
				bal = p.balances.btc.first_or_create(curtype: "crypto")
				bal.update(amount: bal.amount.to_f - prem)
				puts "#{p.username}\tbuys #{dir} option for #{prem}"
			end
			puts "------------------------\n"
		end	


		# Open a 5 minute round every 5 minutes
		if ([0,5,10,15,20,25,30,35,40,45,50,55].include? Time.now.utc.strftime("%M").to_i)
			newround = BinaryRound.new do |nr|
				nr.open!
				nr.btcusd5!
				nr.starttime = Time.now.utc.beginning_of_minute + 5.minutes
				nr.endtime = Time.now.utc.beginning_of_minute + 10.minutes
				nr.save
				puts "------------------------"
				puts "Opened #{nr.id}\tType:\t#{nr.roundtype}"
				#no fake bets yet
				puts "------------------------\n"
			end
		end

=begin
		# Open a New btcusd60PLAY Round 
		newround = BinaryRound.new do |nr|
			nr.open!
			nr.btcusd60play!
			nr.starttime = Time.now.utc.beginning_of_minute + 1.minute
			nr.endtime = Time.now.utc.beginning_of_minute + 2.minutes
			nr.save
			puts "------------------------"
			puts "Opened #{nr.id}\tType:\t#{nr.roundtype}"

			puts "------------------------\n"
		end
=end

	else 
		puts "Market Closed - no new rounds bro"
	end
end
