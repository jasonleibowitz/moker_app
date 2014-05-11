class CreateFoursquareReviews < ActiveRecord::Migration
  def change
    create_table :foursquare_reviews do |t|
      t.string :username
      t.string :user_pic
      t.text :comment
    end
  end
end
