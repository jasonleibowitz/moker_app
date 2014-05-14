class AddFoursquareReviewRefToCoffeeShop < ActiveRecord::Migration
  def change
    add_reference :coffee_shops, :foursquare_reviews, index: true
  end
end
