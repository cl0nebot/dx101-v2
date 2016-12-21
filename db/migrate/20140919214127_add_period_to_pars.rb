class AddPeriodToPars < ActiveRecord::Migration
  def change
    add_column :pars, :period, :integer
  end
end
