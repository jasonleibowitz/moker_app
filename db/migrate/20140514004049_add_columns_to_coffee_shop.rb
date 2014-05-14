class AddColumnsToCoffeeShop < ActiveRecord::Migration
  def change
    add_column :coffee_shops, :total_wifi_reviews, :integer
    add_column :coffee_shops, :total_wifi_upvotes, :integer
    add_column :coffee_shops, :total_outlet_reviews, :integer
    add_column :coffee_shops, :total_outlet_upvotes, :integer
    add_column :coffee_shops, :total_workspace_reviews, :integer
    add_column :coffee_shops, :total_workspace_upvotes, :integer
    add_column :coffee_shops, :total_coffee_quality_reviews, :integer
    add_column :coffee_shops, :total_coffee_quality_upvotes, :integer
  end
end

