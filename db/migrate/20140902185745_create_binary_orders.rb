class CreateBinaryOrders < ActiveRecord::Migration
  def change
    create_table :binary_orders do |t|
      t.references :user, index: true
      t.references :binary_round, index: true
      t.integer :ordertype
      t.integer :order
      t.decimal :premium, precision: 16, scale: 8
      t.decimal :prembalance, precision: 16, scale: 8
      t.decimal :pool, precision: 16, scale: 8
      t.decimal :sysbonus, precision: 16, scale: 8
      t.decimal :depbonus, precision: 16, scale: 8
      t.decimal :affpay, precision: 16, scale: 8
      t.boolean :itm
      t.decimal :itmpayout, precision: 16, scale: 8
      t.decimal :profit, precision: 16, scale: 8


      t.timestamps
    end
  end
end
