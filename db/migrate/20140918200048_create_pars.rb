class CreatePars < ActiveRecord::Migration
  def change
    create_table :pars do |t|
      t.references :user, index: true
      t.datetime :date
      t.integer :rounds
      t.integer :activerounds
      t.decimal :premiums, precision: 16, scale: 8
      t.integer :wins
      t.integer :losses
      t.float :accuracy

      t.timestamps
    end
  end
end
