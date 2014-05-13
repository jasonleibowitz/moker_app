class AddTimestampsToFoursquareReviews < ActiveRecord::Migration
  def change
    add_column :foursquare_reviews, :created_at, :datetime
    add_column :foursquare_reviews, :updated_at, :datetime
  end
end
