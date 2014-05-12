class CreateCoffeeShops < ActiveRecord::Migration
  def change
    create_table :coffee_shops do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :postal_code
      t.string :avatar
      t.string :url
      t.string :phone_number
      t.string :hours
      t.integer :rating
      t.integer :wifi_rating
      t.integer :outlet_rating
      t.integer :workspace_rating
      t.timestamps
    end
  end
end
