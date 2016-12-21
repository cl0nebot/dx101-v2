class AddRoundTypeToBinaryRound < ActiveRecord::Migration
  def change
    add_column :binary_rounds, :roundtype, :integer
  end
end
