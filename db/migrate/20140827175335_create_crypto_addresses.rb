class CreateCryptoAddresses < ActiveRecord::Migration
  def change
    create_table :crypto_addresses do |t|
      t.string :address
      t.integer :currency
      t.boolean :active
      t.integer :addrtype
      t.references :user, index: true

      t.timestamps
    end
  end
end
