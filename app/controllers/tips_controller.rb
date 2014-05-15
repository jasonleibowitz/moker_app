class TipsController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create]

  def index
    @coffee_shop = CoffeeShop.find(params[:coffee_shop_id])
    @tips = @coffee_shop.tips
  end

  def show
    @coffee_shop = CoffeeShop.find(params[:coffee_shop_id])
    @tip = Tip.find(params[:id])
  end

  def new
    @coffee_shop = CoffeeShop.find(params[:coffee_shop_id])
    @tip = Tip.new
    render :layout => "simple_layout"
  end

  def create
    @coffee_shop = CoffeeShop.find(params[:coffee_shop_id])
    @tip = Tip.new(tip_params)
    @tip.coffee_shop = @coffee_shop
    @tip.user = current_user
    @tip.save!
    redirect_to @coffee_shop
  end

  private
  def tip_params
    return params.require(:tip).permit(:comment)
  end

end
