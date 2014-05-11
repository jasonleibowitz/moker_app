class FoursquareReview < ApplicationController

  def index
    @foursquare_reviews = FoursquareReview.all
  end

  def show
    @foursquare_reviews = FoursquareReview.find(params[:id])
  end

end
