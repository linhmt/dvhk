namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    73.times do
      User.all.each do |user|
        user.passengers.create!(
          :pax_name => Faker::Lorem.sentence,
          :personal_id => "542346",
          :routing_id => rand(10) + 7,
          :priority_id => rand(8) + 3,
          :ticket_class => ['K', 'C', 'V'].sample,
          :remark => Faker::Lorem.sentences()
        )
        user.briefingposts.create!(
          :content => Faker::Lorem.sentences,
          :active_shift => rand(4),
          :active_date => Time.now.to_date.advance(:days => rand(5)),
          :is_active => true,
          :is_domestic => [true, false].sample,
          :is_departure => [true, false].sample)
      end
    end
    Passenger.reset_all
  end
end
