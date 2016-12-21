class BonusPool < ActiveRecord::Base

	has_many :pars

	enum bonustype: [:daily, :weekly, :monthly, :yearly]
end
