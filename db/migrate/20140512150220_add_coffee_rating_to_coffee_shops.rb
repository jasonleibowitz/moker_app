class AddCoffeeRatingToCoffeeShops < ActiveRecord::Migration
  def change
    add_column :coffee_shops, :coffee_rating, :float
    change_column :coffee_shops, :wifi_rating, :float
    change_column :coffee_shops, :outlet_rating, :float
    change_column :coffee_shops, :workspace_rating, :float
  end
end
