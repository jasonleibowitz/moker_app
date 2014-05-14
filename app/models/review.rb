class Review < ActiveRecord::Base

  belongs_to :coffee_shop
  belongs_to :user

  # validates :outlet_rating, inclusion: [true, false], :message => 'Jason is a scrumbag'
  validates :outlet_rating, :workspace_rating, :wifi_rating, :coffee_rating, :inclusion => { :in => [true, false], :message => "was not filled in" }

end

