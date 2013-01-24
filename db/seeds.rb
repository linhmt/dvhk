# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Routing.delete_all
Routing.create(:routing => 'SGN-HAN', :destination => 'HANOI', :is_domestic => true)
Routing.create(:routing => 'SGN-DAD', :destination => 'DA NANG', :is_domestic => true)
Routing.create(:routing => 'SGN-MEL', :destination => 'MELBOURNE-AUSTRALIA', :is_domestic => false)

Passenger.delete_all
Passenger.create(:pax_name => "Passenger 1",
  :personal_id => "B1232",
  :routing_id => 1,
  :remark => "Test pax 1",
  :ticket_class => 'C')

Priority.create(:description => "PLATIUM VNA",
  :pri_level => 3,
  :pri_name => "PLA")
SystemConstant.create(
  :name => "valid_position",
  :value => ["PK1","GT1"])             
