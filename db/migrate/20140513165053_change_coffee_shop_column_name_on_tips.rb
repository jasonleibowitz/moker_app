class ChangeCoffeeShopColumnNameOnTips < ActiveRecord::Migration
  def change
    rename_column :tips, :coffeeshop_id, :coffee_shop_id
  end
end
