namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    50.times do
      User.all.each do |user|
        user.briefingposts.create!(:content => Faker::Lorem.sentence(1))
      end
    end
    Passenger.reset_all
  end
end
