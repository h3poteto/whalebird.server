# coding: utf-8
FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Lorem.characters(10) }
    uid { rand(100000).to_s }
    provider { "twitter" }
    name { Faker::Name.name }
    screen_name { Faker::Name.first_name }
    oauth_token { Faker::Lorem.characters(200) }
    oauth_token_secret { Faker::Lorem.characters(100) }
    factory :user_available do
      uid { 124441475 }
      name { "ぽてと(Akira Fukushima)" }
      screen_name { "h3_poteto" }
      oauth_token { ENV["TWITTER_ACCESS_TOKEN"] }
      oauth_token_secret { ENV["TWITTER_ACCESS_TOKEN_SECRET"] }
    end
  end

end
