class AddBonusPoolsToPars < ActiveRecord::Migration
	change_table :pars do |t|
    t.references :bonus_pools
  end
end
