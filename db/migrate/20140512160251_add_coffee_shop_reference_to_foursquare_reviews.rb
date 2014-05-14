class AddCoffeeShopReferenceToFoursquareReviews < ActiveRecord::Migration
  def change
    add_column :foursquare_reviews, :coffeeshop_id, :integer
  end
end
