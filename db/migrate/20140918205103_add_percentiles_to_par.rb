class AddPercentilesToPar < ActiveRecord::Migration
  def change
    add_column :pars, :p_percentile, :decimal
    add_column :pars, :a_percentile, :decimal
    add_column :pars, :r_percentile, :decimal

  end
end
