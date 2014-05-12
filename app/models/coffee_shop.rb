class CoffeeShop < ActiveRecord::Base
  has_many :foursquarereviews
  has_many :reviews

  FOURSQURE_EXPLORE_PREFIX = 'https://api.foursquare.com/v2/venues/explore?client_id=QAOJQNY2JJHJC2DNYHLDH0EEBPFDZAXEOA44DY1X1BZJOJOD&client_secret=4IBKRTTJCKADRNBP3GMLCOYJUF3N21G2HX1VEIE0C4E5D5PX&v=20140315&ll='
  FOURSQURE_EXPLORE_SUFFIX = '&query=coffee&venuePhotos=1'

  def self.cache_from_foursquare(zipcode)
    zip = zipcode.to_s
    lat = zip.to_lat
    lon = zip.to_lon
    response = HTTParty.get("#{FOURSQURE_EXPLORE_PREFIX}+#{lat}+,+#{lon}+#{FOURSQURE_EXPLORE_SUFFIX}")
    response["response"]["groups"][0]["items"].each do |coffee_shop|
      if (coffee_shop["venue"]["rating"] != nil) && (coffee_shop["venue"]["rating"] > 7.3)
        shop = CoffeeShop.find_or_create_by(phone_number: coffee_shop["venue"]["contact"]["formattedPhone"])
        if shop.name == nil
          shop.rating = coffee_shop["venue"]["rating"].to_f
          shop.avatar = "#{coffee_shop["venue"]["photos"]["groups"][0]["items"].first["prefix"]}+original+#{coffee_shop["venue"]["photos"]["groups"][0]["items"].first["suffix"]}"
        end
        shop.name = coffee_shop["venue"]["name"]
        shop.address = coffee_shop["venue"]["location"]["address"]
        shop.city = coffee_shop["venue"]["location"]["city"]
        shop.postal_code = coffee_shop["venue"]["location"]["postalCode"]
        shop.save!
      end
    end
  end

end
