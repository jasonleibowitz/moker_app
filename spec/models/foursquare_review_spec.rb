require_relative '../spec_helper'
require 'pry'

describe FoursquareReview do
  before :each do
    CoffeeShop.cache_from_foursquare(10010)
    @shop = CoffeeShop.first
    @ranked_shops = CoffeeShop.where('total_wifi_reviews > ?', 0)
    FoursquareReview.add_foursquare_reviews
  end

  describe ".add_foursquare_reviews" do
    it "should iterate over all CoffeeShops and all foursquare reviews to each shop" do
      expect(@shop.foursquare_reviews).not_to eq([])
    end
  end

  describe ".update_rating_based_on_foursquare_reviews" do
    it "should search all foursquare tips and edit each coffee shop's wifi, outlet and workspace ratings if it finds any positive or negative comments relating to any of these ratings" do
      FoursquareReview.update_rating_based_on_foursquare_reviews
      expect(@ranked_shops.first.total_wifi_reviews).not_to eq(0)
    end
  end

end
