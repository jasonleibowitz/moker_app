class User < ActiveRecord::Base

  has_many :authorizations
  has_many :reviews
  has_many :tips
  belongs_to :coffee_shop

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :omniauthable, :omniauth_providers => [:facebook]

  def self.find_for_facebook_oauth(auth)
    where(auth.slice(:provider, :uid)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def check_in(coffee_shop)
    self.coffee_shop_id = coffee_shop.to_i
    self.check_in_time = Time.now
    self.save!
  end

  def check_out
    self.coffee_shop_id = nil
    self.check_in_time = nil
    self.save!
  end

end
