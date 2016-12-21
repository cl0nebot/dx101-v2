class CreateBalances < ActiveRecord::Migration
  def change
    create_table :balances do |t|
      t.decimal :amount, precision: 16, scale: 8
      t.integer :currency, default: 0, null: false
      t.references :user, index: true

      t.timestamps
    end
  end
end
