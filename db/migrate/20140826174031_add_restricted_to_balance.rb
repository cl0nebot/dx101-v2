class AddRestrictedToBalance < ActiveRecord::Migration
  def change
    add_column :balances, :restricted, :decimal, precision: 16, scale: 8
    add_column :balances, :curtype, :integer
  end
end
