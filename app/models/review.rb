class Review < ActiveRecord::Base

  belongs_to :coffee_shop
  belongs_to :user

end
