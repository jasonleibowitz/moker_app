class ChangeCoffeeShopIdNameonFoursquareReviews < ActiveRecord::Migration
  def change
    rename_column :foursquare_reviews, :coffeeshop_id, :coffee_shop_id
  end
end
