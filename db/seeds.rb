# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Admin.where(email: ENV["SERVER_EMAIL"]).first_or_create(
  email: ENV["SERVER_EMAIL"],
  password: ENV["SERVER_EMAIL_PASSWORD"],
  password_confirmation: ENV["SERVER_EMAIL_PASSWORD"]
)
