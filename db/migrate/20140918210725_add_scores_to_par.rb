class AddScoresToPar < ActiveRecord::Migration
  def change
  	 add_column :pars, :dayrank, :integer
  	 add_column :pars, :weekrank, :integer
  	 add_column :pars, :monthrank, :integer
     add_column :pars, :yearrank, :integer
     
     add_column :pars, :dayscore, :decimal
     add_column :pars, :weekscore, :decimal
  	 add_column :pars, :monthscore, :decimal
     add_column :pars, :yearscore, :decimal

     add_column :pars, :daypayout, :decimal, precision: 16, scale: 8
     add_column :pars, :weekpayout, :decimal, precision: 16, scale: 8
  	 add_column :pars, :monthpayout, :decimal, precision: 16, scale: 8
  	 add_column :pars, :yearpayout, :decimal, precision: 16, scale: 8
  end
end
