FactoryGirl.define do
  factory :admin do
    email { Faker::Internet.email }
    password { Faker::Lorem.characters(10) }
  end

end
