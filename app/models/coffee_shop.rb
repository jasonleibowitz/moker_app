class CoffeeShop < ActiveRecord::Base

  has_many :foursquare_reviews
  has_many :reviews
  has_many :tips

  FOURSQURE_EXPLORE_PREFIX = 'https://api.foursquare.com/v2/venues/explore?client_id=QAOJQNY2JJHJC2DNYHLDH0EEBPFDZAXEOA44DY1X1BZJOJOD&client_secret=4IBKRTTJCKADRNBP3GMLCOYJUF3N21G2HX1VEIE0C4E5D5PX&v=20140315&ll='
  FOURSQURE_EXPLORE_SUFFIX = '&query=coffee&venuePhotos=1'

  def self.cache_from_foursquare(zipcode)
    zip = zipcode.to_s
    lat = zip.to_lat
    lon = zip.to_lon
    response = HTTParty.get("#{FOURSQURE_EXPLORE_PREFIX}#{lat},#{lon}#{FOURSQURE_EXPLORE_SUFFIX}")
    response["response"]["groups"][0]["items"].each do |coffee_shop|
      if (coffee_shop["venue"]["rating"] != nil) && (coffee_shop["venue"]["rating"] > 7.3)
        shop = CoffeeShop.find_or_create_by(phone_number: coffee_shop["venue"]["contact"]["formattedPhone"])
        if shop.name == nil
          shop.rating = coffee_shop["venue"]["rating"].to_f
          shop.coffee_rating = coffee_shop["venue"]["rating"].to_f
          shop.avatar = "#{coffee_shop["venue"]["photos"]["groups"][0]["items"].first["prefix"]}original#{coffee_shop["venue"]["photos"]["groups"][0]["items"].first["suffix"]}"
          shop.foursquare_id = coffee_shop["venue"]["id"]
          shop.wifi_rating = 0
          shop.outlet_rating = 0
          shop.workspace_rating = 0
        end
        shop.name = coffee_shop["venue"]["name"]
        shop.address = coffee_shop["venue"]["location"]["address"]
        shop.city = coffee_shop["venue"]["location"]["city"]
        shop.postal_code = coffee_shop["venue"]["location"]["postalCode"]
        shop.lat = coffee_shop["venue"]["location"]["lat"]
        shop.lon = coffee_shop["venue"]["location"]["lng"]
        shop.save!
      end
    end
  end

  def self.coffeeshop_user_distance(user_zip)
    lat1 = user_zip.to_lat.to_f
    long1 = user_zip.to_lon.to_f
    user_city = user_zip.to_s.to_region(:city => true)
    distance_hash = {}
    CoffeeShop.where(city: user_city).each do |shop|
      lat2 = shop.postal_code.to_lat.to_f
      long2 = shop.postal_code.to_lon.to_f
      distance_hash[shop] = shop.haversine(lat1, long1, lat2, long2)
    end
    sorted_hash = distance_hash.sort_by {|key, value| value}
    return sorted_hash.first 10
  end

  def haversine(lat1, long1, lat2, long2)
    dtor = Math::PI/180
    r = 3959

    rlat1 = lat1 * dtor
    rlong1 = long1 * dtor
    rlat2 = lat2 * dtor
    rlong2 = long2 * dtor

    dlon = rlong1 - rlong2
    dlat = rlat1 - rlat2

    a = power(Math::sin(dlat/2), 2) + Math::cos(rlat1) * Math::cos(rlat2) * power(Math::sin(dlon/2), 2)
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
    d = r * c

    return d
  end

  def update_wifi_rating(value)
    if value == true
      self.total_wifi_reviews += 1
      self.total_wifi_upvotes += 1
      self.wifi_rating = (total_wifi_upvotes / total_wifi_reviews)
      self.save!
    elsif value == false
      self.total_wifi_reviews += 1
      self.wifi_rating = (total_wifi_upvotes / total_wifi_reviews)
      self.save!
    end
  end

  def update_outlet_rating(value)
    if value == true
      self.total_outlet_reviews += 1
      self.total_outlet_upvotes += 1
      self.outlet_rating = (total_outlet_upvotes / total_outlet_reviews)
      self.save!
    elsif value == false
      self.total_outlet_reviews += 1
      self.outlet_rating = (total_outlet_upvotes / total_outlet_reviews)
      self.save!
    end
  end

  def update_workspace_rating(value)
    if value == true
      self.total_workspace_reviews += 1
      self.total_workspace_upvotes += 1
      self.workspace_rating = (total_workspace_upvotes / total_workspace_reviews)
      self.save!
    elsif value == false
      self.total_workspace_reviews += 1
      self.workspace_rating = (total_workspace_upvotes / total_workspace_reviews)
      self.save!
    end
  end

  def recalculate_rating

  end


  private
  def power(num, pow)
    num ** pow
  end

end
