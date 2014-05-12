class CoffeeshopsController < ApplicationController

  def index
    @coffee_shops = CoffeeShop.all
  end

  def show
    @coffee_shop = CoffeeShop.find(params[:id])
  end

  def test

  end

end
