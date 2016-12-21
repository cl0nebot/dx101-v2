class AddPaidInToBinaryRound < ActiveRecord::Migration
  def change
    add_column :binary_rounds, :pool_in, :decimal, precision: 16, scale: 8
    add_column :binary_rounds, :pool_out, :decimal, precision: 16, scale: 8
    add_column :binary_rounds, :callsum, :decimal, precision: 16, scale: 8
    add_column :binary_rounds, :putsum, :decimal, precision: 16, scale: 8
    add_column :binary_rounds, :payratio, :float
  end
end
