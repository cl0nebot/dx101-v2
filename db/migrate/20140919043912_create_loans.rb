class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.references :user, index: true
      t.decimal :amount, precision: 16, scale: 8
      t.integer :currency

      t.timestamps
    end
  end
end
