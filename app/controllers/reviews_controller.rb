class ReviewsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create]

  def index
    coffee_shop = CoffeeShop.find(params[:coffee_shop_id])
    @reviews = coffee_shop.reviews
  end

  def show
    coffee_shop = CoffeeShop.find(params[:coffee_shop_id])
    @review = coffee_shop.reviews.find(params[:id])
  end

  def new
    # if current_user
    @coffee_shop = CoffeeShop.find(params[:coffee_shop_id])
    @review = Review.new
    render :layout => "simple_layout"
  end

  def create
    @coffee_shop = CoffeeShop.find(params[:coffee_shop_id])
    @review = Review.new(review_params)
    @review.coffee_shop = @coffee_shop
    @review.user_id = current_user.id
    if @review.valid?
      @coffee_shop.update_wifi_rating(@review.wifi_rating)
      @coffee_shop.update_outlet_rating(@review.outlet_rating)
      @coffee_shop.update_workspace_rating(@review.workspace_rating)
      @coffee_shop.update_coffee_rating(@review.coffee_rating)
      @review.save!
      redirect_to @coffee_shop
    else
      render 'new'
    end
  end

  private
  def review_params
    return params.require(:review).permit(:outlet_rating, :wifi_rating, :workspace_rating, :coffee_rating)
  end

end
