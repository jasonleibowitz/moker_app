class AddFoursquareIDtoCoffeeShops < ActiveRecord::Migration
  def change
    add_column :coffee_shops, :foursquare_id, :string
  end
end
