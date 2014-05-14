class RemoveFoursquareReviewIdFromCoffeeShops < ActiveRecord::Migration
  def change
    remove_column :coffee_shops, :foursquare_reviews_id
  end
end
