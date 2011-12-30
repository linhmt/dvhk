namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    73.times do
      User.all.each do |user|
        user.briefingposts.create!(:content => Faker::Lorem.sentence(1),
          :active_shift => rand(4),
          :active_date => Time.now.to_date.advance(:days => rand(5)),
          :is_domestic => [true, false].sample,
          :is_departure => [true, false].sample)
      end
    end
    Passenger.reset_all
  end
end
