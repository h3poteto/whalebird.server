# coding: utf-8
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  uid                    :string(255)      default(""), not null
#  provider               :string(255)      default(""), not null
#  name                   :string(255)
#  screen_name            :string(255)
#  oauth_token            :string(255)
#  oauth_token_secret     :string(255)
#  userstream             :boolean          default(FALSE), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#

FactoryBot.define do
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
