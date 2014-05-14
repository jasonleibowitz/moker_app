class AddLatandLongToCoffeeShops < ActiveRecord::Migration
  def change
    add_column :coffee_shops, :lat, :float
    add_column :coffee_shops, :lon, :float
  end
end
