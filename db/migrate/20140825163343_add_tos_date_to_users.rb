class AddTosDateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tosdate, :datetime
  end
end
