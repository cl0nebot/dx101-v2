class ConsolidateScoresAndRanksInPar < ActiveRecord::Migration
  def change
  	rename_column :pars, :dayscore, :score
  	remove_column :pars, :weekscore
  	remove_column :pars, :monthscore
  	remove_column :pars, :yearscore

  	rename_column :pars, :dayrank, :rank
  	remove_column :pars, :weekrank
  	remove_column :pars, :monthrank
  	remove_column :pars, :yearrank
  end
end
