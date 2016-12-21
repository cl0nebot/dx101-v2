class FixBinaryOrder < ActiveRecord::Migration
  def change
  	rename_column :binary_orders, :order, :direction
  end
end
