class CoffeeshopsController < ApplicationController

  def index
    # @coffee_shops = CoffeeShop.all
  end

  def show
    @coffee_shop = CoffeeShop.find(params[:id])
  end

  def search
  end

  def results
    zip_code = params[:query]
    @sorted_coffee_shops = CoffeeShop.coffeeshop_user_distance(zip_code)
  end

end
