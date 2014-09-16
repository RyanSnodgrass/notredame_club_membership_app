# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.delete_all
Club.delete_all
Membership.delete_all
user_list = [
  [ "Clark", "Kent",    "1938-04-18", "clark@kent.com",    "superman",       "superman"],
# "batman" was too short a password. settled on "thedarkknight"
  [ "Bruce", "Wayne",   "1939-05-12", "bruce@wayne.com",   "thedarkknight",  "thedarkknight"],
  [ "Diana", "Prince",  "1941-11-14", "diana@prince.com",  "wonderwoman",    "wonderwoman"],
  [ "Peter", "Quill",   "1976-01-07", "peter@quill.com",   "starlord",       "starlord"],
  [ "Hal",   "Jordan",  "1959-10-10", "hal@jordan.com",    "greenlantern",   "greenlantern"],
  [ "Steve", "Rodgers", "1941-03-16", "steve@rodgers.com", "captainamerica", "captainamerica"]
]


user_list.each do |fname, lname, bday, email, alter, ego|
  User.create(f_name: fname, l_name: lname, dob: bday, email: email, password: alter, password_confirmation: ego)
end

club_list = [
  ["Justice League", "Super Sweet", true, User.find_by_f_name("Clark").id],
  ["Gaurdians of the Galaxy", "Super Awesome", false, User.find_by_f_name("Peter").id],
  ["The Avengers", "Old School", true, User.find_by_f_name("Steve").id]
]

club_list.each do |name, description, accepting, creator|
  Club.create(name: name, description: description, accepting: accepting, created_by: creator)
end