class AddCheckInDeetsToUser < ActiveRecord::Migration
  def change
    add_column :users, :coffee_shop_id, :integer
    add_column :users, :check_in_time, :datetime
  end
end
