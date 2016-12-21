class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user, index: true
      t.integer :pin
      t.string :residence
      t.string :citizenship

      t.timestamps
    end
  end
end
