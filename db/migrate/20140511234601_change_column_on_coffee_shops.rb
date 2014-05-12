class ChangeColumnOnCoffeeShops < ActiveRecord::Migration
  def change
    change_column :coffee_shops, :rating, :float
  end
end
