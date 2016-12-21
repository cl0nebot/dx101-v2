class AddStatusToTxes < ActiveRecord::Migration
  def change 
    add_column :txes, :txid, :string, unique: true    
    add_column :txes, :status, :integer
    add_column :txes, :confirmations, :integer
    add_column :txes, :address, :string
    add_column :txes, :complete_at, :datetime
    add_column :txes, :cancelled_at, :datetime
  end
end

