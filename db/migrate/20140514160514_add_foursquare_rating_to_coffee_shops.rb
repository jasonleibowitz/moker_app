class AddFoursquareRatingToCoffeeShops < ActiveRecord::Migration
  def change
    add_column :coffee_shops, :foursquare_rating, :float
  end
end
