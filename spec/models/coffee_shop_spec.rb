require_relative '../spec_helper'

describe CoffeeShop do

  before :each do
    CoffeeShop.create(name: "Pushcart Coffee", address: "362 2nd Ave", postal_code: '10010', avatar: 'https://irs1.4sqi.net/img/general/original/5497982_gHyWLCApRCC3WGbx1O-7ya8WYz7iQKGqku2Pp_TjLN4.jpg', phone_number: '(646) 476-8416', rating: 9.41, wifi_rating: 0, outlet_rating: 0, workspace_rating: 0, lat: 40.7363725255321, lon: -73.9818981457148, coffee_rating: 0.941, foursquare_id: '5058bd06e4b0e27671bf4399', total_wifi_reviews: 0, total_wifi_upvotes: 0, total_outlet_reviews: 0, total_outlet_upvotes: 0, total_workspace_reviews: 0, total_workspace_upvotes: 0, total_coffee_quality_reviews: 0, total_coffee_quality_upvotes: 0, foursquare_rating: 0.941)
  end

  it { should have_many :foursquare_reviews }
  it { should have_many :reviews }
  it { should have_many :tips }

  describe ".cache_from_foursquare" do
    it "should pull all coffee shops within the specififed zipcode and save them to the database as new Coffee Shop objects" do
      CoffeeShop.cache_from_foursquare(10010)
      expect(CoffeeShop.all).not_to eq([])
    end
  end

  describe ".coffeeshop_user_distance" do
    it "should return the first 10 coffeeshops near the specified zipcode" do
      CoffeeShop.cache_from_foursquare(10010)
      @shop = CoffeeShop.first
      expect(CoffeeShop.coffeeshop_user_distance(10010)).to have(10).item
    end
  end

  describe "#update_wifi_rating" do
    it "should upvote the coffee shop's wifi rating if the argument is true and then update coffee shop's wifi rating and recalculate its total rating" do
      CoffeeShop.cache_from_foursquare(10010)
      @shop = CoffeeShop.first
      @shop.update_wifi_rating(true)
      expect(@shop.total_wifi_reviews) == 1
      expect(@shop.total_wifi_upvotes) == 1
      expect(@shop.wifi_rating) == 1
    end
    it "should downvote the coffee shop's wifi rating if the argument is false and then update the coffee shop's wifi rating and recalculate its total rating" do
      CoffeeShop.cache_from_foursquare(10010)
      @shop = CoffeeShop.first
      @shop.update_wifi_rating(false)
      expect(@shop.total_wifi_reviews) == 1
      expect(@shop.total_wifi_upvotes) == 0
      expect(@shop.wifi_rating) == 0
    end
  end

  describe "#update_outlet_rating" do
    it "should upvote the coffee shop's outlet rating if the argument is true and then update coffee shop's outlet rating and recalculate its total rating" do
      CoffeeShop.cache_from_foursquare(10010)
      @shop = CoffeeShop.first
      @shop.update_outlet_rating(true)
      expect(@shop.total_outlet_reviews) == 1
      expect(@shop.total_outlet_upvotes) == 1
      expect(@shop.outlet_rating) == 1
    end
    it "should downvote the coffee shop's outlet rating if the argument is false and then update the coffee shop's outlet rating and recalculate its total rating" do
      CoffeeShop.cache_from_foursquare(10010)
      @shop = CoffeeShop.first
      @shop.update_outlet_rating(false)
      expect(@shop.total_outlet_reviews) == 1
      expect(@shop.total_outlet_upvotes) == 0
      expect(@shop.outlet_rating) == 0
    end
  end

  describe "#update_workspace_rating" do
    it "should upvote the coffee shop's workspace rating if the argument is true and then update coffee shop's workspace rating and recalculate its total rating" do
      CoffeeShop.cache_from_foursquare(10010)
      @shop = CoffeeShop.first
      @shop.update_workspace_rating(true)
      expect(@shop.total_workspace_reviews) == 1
      expect(@shop.total_workspace_upvotes) == 1
      expect(@shop.workspace_rating) == 1
    end
    it "should downvote the coffee shop's workspace rating if the argument is false and then update the coffee shop's workspace rating and recalculate its total rating" do
      CoffeeShop.cache_from_foursquare(10010)
      @shop = CoffeeShop.first
      @shop.update_workspace_rating(false)
      expect(@shop.total_workspace_reviews) == 1
      expect(@shop.total_workspace_upvotes) == 0
      expect(@shop.workspace_rating) == 0
    end
  end

  describe "#update_coffee_rating" do
    it "should upvote the coffee shop's coffee rating if the argument is true and then update coffee shop's coffee rating and recalculate its total rating" do
      CoffeeShop.cache_from_foursquare(10010)
      @shop = CoffeeShop.first
      @shop.update_coffee_rating(true)
      expect(@shop.total_coffee_quality_reviews) == 1
      expect(@shop.total_coffee_quality_upvotes) == 1
      expect(@shop.coffee_rating) == 1
    end
    it "should downvote the coffee shop's coffee rating if the argument is false and then update the coffee shop's coffee rating and recalculate its total rating" do
      CoffeeShop.cache_from_foursquare(10010)
      @shop = CoffeeShop.first
      @shop.update_coffee_rating(false)
      expect(@shop.total_coffee_quality_reviews) == 1
      expect(@shop.total_coffee_quality_upvotes) == 0
      expect(@shop.coffee_rating) == 0
    end
  end

end
