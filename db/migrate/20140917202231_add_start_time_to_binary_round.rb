class AddStartTimeToBinaryRound < ActiveRecord::Migration
  def change
    add_column :binary_rounds, :starttime, :datetime
    add_column :binary_rounds, :endtime, :datetime
  end
end
