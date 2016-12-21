class CreateExtQuotes < ActiveRecord::Migration
  def change
    create_table :ext_quotes do |t|
      t.string :source
      t.integer :pair, default: 0
      t.decimal :val, precision: 16, scale: 8
      t.datetime :quotetime
      
      t.timestamps
    end
  end
end
