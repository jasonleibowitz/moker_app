class AddPictureToFoursquareReview < ActiveRecord::Migration
  def change
    add_column :foursquare_reviews, :picture, :string
  end
end
