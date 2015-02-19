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
  end

end
