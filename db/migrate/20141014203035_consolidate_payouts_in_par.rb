class ConsolidatePayoutsInPar < ActiveRecord::Migration
  def change
  	rename_column :pars, :daypayout, :payout
  	remove_column :pars, :weekpayout
  	remove_column :pars, :monthpayout
  	remove_column :pars, :yearpayout
  end
end
