class FoursquareReview < ActiveRecord::Base

  belongs_to :coffee_shop

  FOURSQUARE_VENUE_PREFIX = 'https://api.foursquare.com/v2/venues/'
  FOURSQUARE_VENUE_SUFFIX = '?client_id=QAOJQNY2JJHJC2DNYHLDH0EEBPFDZAXEOA44DY1X1BZJOJOD&client_secret=4IBKRTTJCKADRNBP3GMLCOYJUF3N21G2HX1VEIE0C4E5D5PX&v=20140315'

  def self.add_foursquare_reviews
    CoffeeShop.all.each do |shop|
      FoursquareReview.cache_from_foursquare(shop)
    end
  end

  def self.cache_from_foursquare(coffeeshop)
    venueID = coffeeshop.foursquare_id
    id = coffeeshop.id
    if coffeeshop.foursquare_reviews = []
      response = HTTParty.get("#{FOURSQUARE_VENUE_PREFIX}#{venueID}#{FOURSQUARE_VENUE_SUFFIX}")
      response["response"]["venue"]["tips"]["groups"][0]["items"].each do |foursquare_tip|
        review = FoursquareReview.create
        review.comment = foursquare_tip["text"] || nil
        review.username = "#{foursquare_tip["user"]["firstName"]} #{foursquare_tip["user"]["lastName"]}" || nil
        review.user_pic ="#{foursquare_tip["user"]["photo"]["prefix"]}original#{foursquare_tip["user"]["photo"]["suffix"]}" || nil
        review.coffee_shop_id = id
        review.save!
      end
    end
  end

end
