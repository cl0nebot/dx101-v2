class CreateAffCodes < ActiveRecord::Migration
  def change
    create_table :aff_codes do |t|
      t.references :user, index: true
      t.string :code

      t.timestamps
    end
  end
end
