class CreateBonusPools < ActiveRecord::Migration
  def change
    create_table :bonus_pools do |t|
      t.integer :bonustype
      t.datetime :startday
      t.decimal :paid_in, precision: 16, scale: 8
      t.decimal :paid_out, precision: 16, scale: 8

      t.timestamps
    end
  end
end
