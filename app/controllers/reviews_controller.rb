class ReviewsController < ApplicationController

  def index
    coffee_shop = CoffeeShop.find(params[:coffee_shop_id])
    @reviews = coffee_shop.reviews
  end

  def show
    coffee_shop = CoffeeShop.find(params[:coffee_shop_id])
    @review = coffee_shop.reviews.find(params[:id])
  end

  def new

    @coffee_shop = CoffeeShop.find(params[:coffee_shop_id])
    @review = Review.new
  end

  def create
    @coffee_shop = CoffeeShop.find(params[:coffee_shop_id])
    @review = Review.new(review_params)
    @review.coffee_shop = @coffee_shop
    @review.user_id = current_user.id
    @review.save!
    redirect_to @coffee_shop
  end

  private
  def review_params
    return params.require(:review).permit(:outlet_rating, :wifi_rating, :workspace_rating, :coffee_rating)
  end

end
