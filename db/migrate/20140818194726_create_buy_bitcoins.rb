class CreateBuyBitcoins < ActiveRecord::Migration
  def change
    create_table :buy_bitcoins do |t|
      t.string :name
      t.string :slug
      t.text :content

      t.timestamps
    end
    add_index :buy_bitcoins, :slug, unique: true
  end
end
