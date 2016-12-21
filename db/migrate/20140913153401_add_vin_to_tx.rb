class AddVinToTx < ActiveRecord::Migration
  def change
    add_column :txes, :vin, :string
  end
end
