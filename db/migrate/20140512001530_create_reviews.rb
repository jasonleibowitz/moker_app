class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :user
      t.references :coffee_shop
      t.boolean :wifi_rating
      t.boolean :outlet_rating
      t.boolean :workspace_rating
      t.boolean :coffee_rating
      t.string :comment
    end
  end
end
