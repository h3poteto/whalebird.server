require "rails_helper"

RSpec.describe Users::ApisController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/users/apis").to route_to("users/apis#index")
    end

    it "routes to #new" do
      expect(:get => "/users/apis/new").not_to be_routable
    end

    it "routes to #show" do
      expect(:get => "/users/apis/1").not_to be_routable
    end

    it "routes to #edit" do
      expect(:get => "/users/apis/1/edit").not_to be_routable
    end

    it "routes to #create" do
      expect(:post => "/users/apis").not_to be_routable
    end

    it "routes to #update" do
      expect(:put => "/users/apis/1").not_to be_routable
    end

    it "routes to #destroy" do
      expect(:delete => "/users/apis/1").not_to be_routable
    end

    it "routest to #home_timeline" do
      expect(:get => "/users/apis/home_timeline").to route_to("users/apis#home_timeline")
    end

    it "routes to #lists" do
      expect(:get => "/users/apis/lists").to route_to("users/apis#lists")
    end

    it "routes to #list_timeline" do
      expect(:get => "/users/apis/list_timeline").to route_to("users/apis#list_timeline")
    end

    it "routes to #mentions" do
      expect(:get => "/users/apis/mentions").to route_to("users/apis#mentions")
    end

    it "routes to #user" do
      expect(:get => "/users/apis/user").to route_to("users/apis#user")
    end

    it "routes to #profile_banner" do
      expect(:get => "/users/apis/profile_banner").to route_to("users/apis#profile_banner")
    end

    it "routes to #user_timeline" do
      expect(:get => "/users/apis/user_timeline").to route_to("users/apis#user_timeline")
    end

    it "routes to #user_favorites" do
      expect(:get => "/users/apis/user_favorites").to route_to("users/apis#user_favorites")
    end

    it "routes to #friends" do
      expect(:get => "/users/apis/friends").to route_to("users/apis#friends")
    end

    it "routes to #followers" do
      expect(:get => "/users/apis/followers").to route_to("users/apis#followers")
    end

    it "routes to #direct_messages" do
      expect(:get => "/users/apis/direct_messages").to route_to("users/apis#direct_messages")
    end

    it "routes to #conversations" do
      expect(:get => "/users/apis/conversations").to route_to("users/apis#conversations")
    end

    it "routes to #search" do
      expect(:get => "/users/apis/search").to route_to("users/apis#search")
    end

    it "routes to #tweet" do
      expect(:post => "/users/apis/tweet").to route_to("users/apis#tweet")
    end

    it "routes to #upload" do
      expect(:post => "/users/apis/upload").to route_to("users/apis#upload")
    end

    it "routes to #retweet" do
      expect(:post => "/users/apis/retweet").to route_to("users/apis#retweet")
    end

    it "routes to #favorite" do
      expect(:post => "/users/apis/favorite").to route_to("users/apis#favorite")
    end

    it "routes to #unfavorite" do
      expect(:post => "/users/apis/unfavorite").to route_to("users/apis#unfavorite")
    end

    it "routes to #delete" do
      expect(:post => "/users/apis/delete").to route_to("users/apis#delete")
    end

    it "routes to #update_settings" do
      expect(:post => "/users/apis/update_settings").to route_to("users/apis#update_settings")
    end

    it "routes to #direct_message_create" do
      expect(:post => "/users/apis/direct_message_create").to route_to("users/apis#direct_message_create")
    end
  end
end
