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
    @tips = @coffee_shop.tips.order(created_at: :desc).includes(:user)
    @picture_reviews_toshow = @coffee_shop.foursquare_reviews.where.not(picture: nil).first(4)
    if @picture_reviews_toshow.count >= 4
      last_pics = @picture_reviews_toshow.count - 4
      @picture_reviews_tohide = @coffee_shop.foursquare_reviews.where.not(picture: nil).last((last_pics))
      @picture_tips_to_show = nil
      @picture_tips_to_hide = @coffee_shop.tips.where.not(picture_file_name: nil)
    else
      @picture_reviews_tohide = nil
      @picture_tips_to_show = @coffee_shop.tips.where.not(picture_file_name: nil).first(4 - @picture_reviews_toshow.count)
      @picture_tips_to_hide = @coffee_shop.tips.where.not(picture_file_name: nil).last(@coffee_shop.tips.where.not(picture_file_name: nil).count - @picture_tips_to_show.count)
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
