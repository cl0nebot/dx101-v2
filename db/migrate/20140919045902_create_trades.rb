class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.references :user, index: true
      t.decimal :amount

      t.timestamps
    end
  end
end
