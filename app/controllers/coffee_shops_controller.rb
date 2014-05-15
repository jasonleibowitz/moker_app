class CoffeeShopsController < ApplicationController

  def index
    @coffee_shops = CoffeeShop.all
    if request.env["HTTP_REFERER"] == 'http://localhost:3000/'
    elsif request.env["HTTP_REFERER"] == nil
    else
      redirect_to :back
    end
  end

  def show
    @coffee_shop = CoffeeShop.find(params[:id])
    @picture_reviews_toshow = @coffee_shop.foursquare_reviews.where.not(picture: nil).first(4)
    if @picture_reviews_toshow.count > 4
      last_pics = @picture_reviews_toshow.count - 4
      @picture_reviews_tohide = @coffee_shop.foursquare_reviews.where.not(picture: nil).last((last_pics))
    else
      @picture_reviews_tohide = nil
    end
  end

  def search
  end

  def results
    if /\A\d{5}(-\d{4})?\z/.match(params[:query]) != nil
      zip_code = params[:query]
      @sorted_coffee_shops = CoffeeShop.coffeeshop_user_distance(zip_code)
    else
      @sorted_coffee_shops = []
      filter = ["coffee", "cafe"]
      query_names = params[:query].downcase.split()
      filter.each do |filter_word|
        query_names.delete_if {|x| x.include? filter_word }
      end
      query_names.each do |searched_word|
        @matching_shops = CoffeeShop.where("name ILIKE ?", "%#{searched_word}%")
        @matching_shops.each do |shop|
          @sorted_coffee_shops.push([shop, shop.rating])
        end
      end
    end
  end

end
