class CreateBinaryRounds < ActiveRecord::Migration
  def change
    create_table :binary_rounds do |t|
      t.integer :status
			t.decimal :open, precision: 16, scale: 8
      t.decimal :close, precision: 16, scale: 8
      t.integer :itm

      t.timestamps
    end
  end
end
