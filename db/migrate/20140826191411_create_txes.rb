class CreateTxes < ActiveRecord::Migration
  def change
    create_table :txes do |t|
      t.integer :txtype
      t.decimal :amount, precision: 16, scale: 8
      t.integer :currency
      t.references :user, index: true

      t.timestamps
    end
  end
end
