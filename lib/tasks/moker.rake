require 'chronic'

task :refresh_check_ins => :environment do
  desc "It iterates through all users and if a user's last check_in_time is over 2 hours ago, it checks out the user"
  User.all.each do |user|
    if user.check_in_time < Chronic.parse("two hours ago")
      user.check_out
    end
  end
end
