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
        unless foursquare_tip["photo"] == nil
          review.picture = "#{foursquare_tip["photo"]["prefix"]}original#{foursquare_tip["photo"]["suffix"]}"
        end
        review.username = "#{foursquare_tip["user"]["firstName"]} #{foursquare_tip["user"]["lastName"]}" || nil
        review.user_pic ="#{foursquare_tip["user"]["photo"]["prefix"]}original#{foursquare_tip["user"]["photo"]["suffix"]}" || nil
        review.coffee_shop_id = id
        puts "#{coffeeshop.name} updated with a review from #{review.username}"
        review.save!
      end
    end
  end

  def self.update_rating_based_on_foursquare_reviews
    wifi_good_list = ['free', 'great', 'fast', 'solid', 'password', 'has', 'strong']
    wifi_bad_list = ['no', 'bad', 'slow', 'had']

    workspace_good_list = ['big']
    workspace_bad_list = ['small', 'no', 'not', 'more', 'wish', 'tight']

    outlet_good_list = ['has', 'alot', 'lot']
    outlet_bad_list = ['not', 'no']

    # Iterate over every coffee shop
    CoffeeShop.all.each do |shop|
      # Iterate over every coffee shop's foursquare reviews
      shop.foursquare_reviews.each do |foursquare_review|
        split_string = foursquare_review.comment.downcase.gsub(/[^0-9a-z]/i, ' ').split()
        # If the split array of this particular coffee shop's particular foursquare comment includes the word wifi, do this
        if split_string.include? "wifi"
          # If the word before 'wifi' contains a word from the good_word list upvote the coffee shop's wifi rating
          wifi_good_list.each do |good_word|
            if split_string[split_string.index("wifi") - 1] == good_word
              shop.update_wifi_rating(true)
            end
          # If the word two before 'wifi' contains a word from the good_word list upvote the coffee shop's wifi rating
            if split_string[split_string.index("wifi") - 2] == good_word
              shop.update_wifi_rating(true)
            end
          end
          # If the word before 'wifi' contains a word from the bad_word list downvote the coffee shop's wifi rating
          wifi_bad_list.each do |bad_word|
            if split_string[split_string.index("wifi") - 1] == bad_word
              shop.update_wifi_rating(false)
            end
          # If the word two before 'wifi' contains a word from the bad_word list downvote the coffee shop's wifi rating
            if split_string[split_string.index("wifi") - 2] == bad_word
              shop.update_wifi_rating(false)
            end
          end
        end
        # If the split array of this particular coffee shop's particular foursquare comment includes the word outlet, do this
        if (split_string.include? "outlets")
          outlet_good_list.each do |good_word|
            # If the word before 'outlet' contains a word from the good_word list upvote the coffee shop's outlet rating
            if split_string[split_string.index("outlets") - 1] == good_word
              shop.update_outlet_rating(true)
            end
            # If the word two before 'outlet' contains a word from the good_word list upvote the coffee shop's outlet rating
            if split_string[split_string.index("outlets") - 2] == good_word
              shop.update_outlet_rating(true)
            end
          end
          outlet_bad_list.each do |bad_word|
            # If the word before 'outlet' contains a word from the bad_word list downvote the coffee shop's outlet rating
            if split_string[split_string.index("outlets") - 1] == bad_word
              shop.update_outlet_rating(false)
            end
            # If the word two before 'outlet' contains a word from the bad_word list downvote the coffee shop's outlet rating
            if split_string[split_string.index("outlets") - 2] == bad_word
              shop.update_outlet_rating(false)
            end
          end
        end
        # Check for tables (aka workspace) in reviews
        if (split_string.include? "tables")
          workspace_good_list.each do |good_word|
            # If the word before 'workspace' contains a word from the good_word list upvote the coffee shop's workspace rating
            if split_string[split_string.index("tables") - 1] == good_word
              shop.update_workspace_rating(true)
            end
            # If the word two before 'workspace' contains a word from the good_word list upvote the coffee shop's workspace rating
            if split_string[split_string.index("tables") - 2] == good_word
              shop.update_workspace_rating(true)
            end
            if split_string[split_string.index("tables") + 1] == good_word
              shop.update_workspace_rating(true)
            end
            if split_string[split_string.index("tables") + 2] == good_word
              shop.update_workspace_rating(true)
            end
          end
          workspace_bad_list.each do |bad_word|
            # If the word before 'workspace' contains a word from the bad_word list downvote the coffee shop's workspace rating
            if split_string[split_string.index("tables") - 1] == bad_word
              shop.update_workspace_rating(false)
            end
            # If the word two before 'workspace' contains a word from the bad_word list downvote the coffee shop's workspace rating
            if split_string[split_string.index("tables") - 2] == bad_word
              shop.update_workspace_rating(false)
            end
            if split_string[split_string.index("tables") + 1] == bad_word
              shop.update_workspace_rating(false)
            end
            if split_string[split_string.index("tables") + 2] == bad_word
              shop.update_workspace_rating(false)
            end
          end
        end
        # Check for space (aka workspace in reviews)
        if (split_string.include? "space")
          workspace_good_list.each do |good_word|
            # If the word before 'workspace' contains a word from the good_word list upvote the coffee shop's workspace rating
            if split_string[split_string.index("space") - 1] == good_word
              shop.update_workspace_rating(true)
            end
            # If the word two before 'workspace' contains a word from the good_word list upvote the coffee shop's workspace rating
            if split_string[split_string.index("space") - 2] == good_word
              shop.update_workspace_rating(true)
            end
            if split_string[split_string.index("space") + 1] == good_word
              shop.update_workspace_rating(true)
            end
            if split_string[split_string.index("space") + 2] == good_word
              shop.update_workspace_rating(true)
            end
          end
          workspace_bad_list.each do |bad_word|
            # If the word before 'workspace' contains a word from the bad_word list downvote the coffee shop's workspace rating
            if split_string[split_string.index("space") - 1] == bad_word
              shop.update_workspace_rating(false)
            end
            # If the word two before 'workspace' contains a word from the bad_word list downvote the coffee shop's workspace rating
            if split_string[split_string.index("space") - 2] == bad_word
              shop.update_workspace_rating(false)
            end
            if split_string[split_string.index("space") + 1] == bad_word
              shop.update_workspace_rating(false)
            end
            if split_string[split_string.index("space") + 2] == bad_word
              shop.update_workspace_rating(false)
            end
          end
        end
      end
    end
  end

end
