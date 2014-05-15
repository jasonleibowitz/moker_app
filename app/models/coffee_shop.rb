class CoffeeShop < ActiveRecord::Base

  has_many :foursquare_reviews
  has_many :reviews
  has_many :tips
  has_many :users

  FOURSQUARE_VENUE_PREFIX = 'https://api.foursquare.com/v2/venues/'
  FOURSQUARE_VENUE_SUFFIX = '?client_id=QAOJQNY2JJHJC2DNYHLDH0EEBPFDZAXEOA44DY1X1BZJOJOD&client_secret=4IBKRTTJCKADRNBP3GMLCOYJUF3N21G2HX1VEIE0C4E5D5PX&v=20140315'

  FOURSQUARE_SEARCH_PREFIX = 'https://api.foursquare.com/v2/venues/search?client_id=QAOJQNY2JJHJC2DNYHLDH0EEBPFDZAXEOA44DY1X1BZJOJOD&client_secret=4IBKRTTJCKADRNBP3GMLCOYJUF3N21G2HX1VEIE0C4E5D5PX&v=20140315&ll='
  FOURSQUARE_SEARCH_SUFFIX = '&limit=50&query=coffee'

  def self.cache_from_foursquare(zipcode)
    zip = zipcode.to_s
    lat = zip.to_lat
    lon = zip.to_lon
    response = HTTParty.get("#{FOURSQUARE_SEARCH_PREFIX}#{lat},#{lon}#{FOURSQUARE_SEARCH_SUFFIX}")
    response["response"]["venues"].each do |coffee_shop|
      shop = CoffeeShop.find_or_create_by(phone_number: coffee_shop["contact"]["formattedPhone"])
      if shop.name == nil
        shop.foursquare_id = coffee_shop["id"]
        shop.wifi_rating = 0
        shop.outlet_rating = 0
        shop.workspace_rating = 0
        shop.total_wifi_reviews = 0
        shop.total_wifi_upvotes = 0
        shop.total_outlet_reviews = 0
        shop.total_outlet_upvotes = 0
        shop.total_workspace_reviews = 0
        shop.total_workspace_upvotes = 0
        shop.total_coffee_quality_reviews = 0
        shop.total_coffee_quality_upvotes = 0

        new_shop = HTTParty.get("#{FOURSQUARE_VENUE_PREFIX}#{shop.foursquare_id}#{FOURSQUARE_VENUE_SUFFIX}")

        # Rating is set on second API call
        shop.rating = new_shop["response"]["venue"]["rating"].to_f
        shop.coffee_rating = (new_shop["response"]["venue"]["rating"].to_f * 0.1)
        shop.foursquare_rating = (new_shop["response"]["venue"]["rating"].to_f * 0.1)
        # Picture grabbed in second API call
        begin:
          shop.avatar = "#{new_shop["response"]["venue"]["photos"]["groups"][0]["items"][0]["prefix"]}original#{new_shop["response"]["venue"]["photos"]["groups"][0]["items"][0]["suffix"]}" || nil
        rescue NoMethodError
          shop.avatar = nil
        end
      end
      shop.name = coffee_shop["name"]
      shop.address = coffee_shop["location"]["address"]
      shop.city = coffee_shop["location"]["city"]
      shop.postal_code = coffee_shop["location"]["postalCode"]
      shop.lat = coffee_shop["location"]["lat"]
      shop.lon = coffee_shop["location"]["lng"]
      shop.url = coffee_shop["url"]
      puts "#{shop.name} has been added to the database."
      shop.save!
    end
  end

  def self.coffeeshop_user_distance(user_zip)
    zip = user_zip.to_s
    lat1 = zip.to_lat.to_f
    long1 = zip.to_lon.to_f
    user_city = zip.to_region(:city => true)
    distance_hash = {}

    CoffeeShop.where(city: user_city).each do |shop|
      lat2 = shop.postal_code.to_lat.to_f
      long2 = shop.postal_code.to_lon.to_f
      distance_hash[shop] = shop.haversine(lat1, long1, lat2, long2)
    end
    sorted_array = distance_hash.sort_by {|key, value| value}
    limited_sorted_array = sorted_array.first(15)
    new_sorted_array = limited_sorted_array.map do |shop|
        shop
    end
    return new_sorted_array.sort {|a,b| b[0].rating <=> a[0].rating}.first 10
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
      self.recalculate_rating
      self.save!
    elsif value == false
      self.total_wifi_reviews += 1
      self.wifi_rating = (total_wifi_upvotes / total_wifi_reviews)
      self.recalculate_rating
      self.save!
    end
  end

  def update_outlet_rating(value)
    if value == true
      self.total_outlet_reviews += 1
      self.total_outlet_upvotes += 1
      self.outlet_rating = (total_outlet_upvotes / total_outlet_reviews)
      self.recalculate_rating
      self.save!
    elsif value == false
      self.total_outlet_reviews += 1
      self.outlet_rating = (total_outlet_upvotes / total_outlet_reviews)
      self.recalculate_rating
      self.save!
    end
  end

  def update_workspace_rating(value)
    if value == true
      self.total_workspace_reviews += 1
      self.total_workspace_upvotes += 1
      self.workspace_rating = (total_workspace_upvotes / total_workspace_reviews)
      self.recalculate_rating
      self.save!
    elsif value == false
      self.total_workspace_reviews += 1
      self.workspace_rating = (total_workspace_upvotes / total_workspace_reviews)
      self.recalculate_rating
      self.save!
    end
  end

  def update_coffee_rating(value)
    if value == true
      self.total_coffee_quality_reviews += 1
      self.total_coffee_quality_upvotes += 1
      self.coffee_rating = (total_coffee_quality_upvotes / total_coffee_quality_reviews)
      self.recalculate_rating
      self.save!
    elsif value == false
      self.total_coffee_quality_reviews +=1
      self.coffee_rating = (total_coffee_quality_upvotes / total_coffee_quality_reviews)
      self.recalculate_rating
      self.save!
    end
  end

  def recalculate_rating
    # Set up weights for each rating. If a rating is zero (defined above) remove the weight from impacting rating calculation below
    foursquare_weight = 80
    if workspace_rating > 0
      workspace_weight = 8
    else
      workspace_weight = 0
    end
    if wifi_rating > 0
      wifi_weight = 6
    else
      wifi_weight = 0
    end
    if coffee_rating > 0
      coffee_weight = 4
    else
      coffee_weight = 0
    end
    if outlet_rating > 0
      outlet_weight = 2
    else
      outlet_weight = 0
    end

    # create weighted rating by multiplying weight by rating
    weighted_foursquare_rating = foursquare_weight * foursquare_rating
    weighted_workspace_rating = workspace_weight * workspace_rating
    weighted_wifi_rating = wifi_weight * wifi_rating
    weighted_coffee_rating = coffee_weight * coffee_rating
    weighted_outlet_rating = outlet_weight * outlet_rating



    # Set total weighted rating by adding all weighted ratings together
    weighted_rating_total = weighted_foursquare_rating + weighted_workspace_rating + weighted_wifi_rating + weighted_coffee_rating + weighted_outlet_rating

    # The updated rating is the weighted rating total over the weights total
    updated_rating = weighted_rating_total / (foursquare_weight + workspace_weight + wifi_weight + coffee_weight + outlet_weight)

    # Update the rating and round to two decimal places
    self.rating = '%.2f' % (updated_rating * 10)
    self.save!
  end


  private
  def power(num, pow)
    num ** pow
  end

end
