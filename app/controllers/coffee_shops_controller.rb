class CoffeeShopsController < ApplicationController

  def index
    # @coffee_shops = CoffeeShop.all
  end

  def show
    @coffee_shop = CoffeeShop.find(params[:id])
  end

  def search
  end

  def results
    if /\A\d{5}(-\d{4})?\z/.match(params[:query]) != nil
      zip_code = params[:query]
      @sorted_coffee_shops = CoffeeShop.coffeeshop_user_distance(zip_code)
    else
      name = params[:query].downcase
      @sorted_coffee_shops = CoffeeShop.where(name: name.downcase)
    end
  end

end
