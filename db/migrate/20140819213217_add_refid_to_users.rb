class AddRefidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :refid, :string
  end
end
