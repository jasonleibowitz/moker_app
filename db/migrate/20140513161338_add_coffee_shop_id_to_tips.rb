class AddCoffeeShopIdToTips < ActiveRecord::Migration
  def change
    add_column :tips, :coffeeshop_id, :integer
  end
end
