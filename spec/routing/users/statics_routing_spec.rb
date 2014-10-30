require "rails_helper"

RSpec.describe Users::StaticsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/users/statics").to route_to("users/statics#index")
    end

    it "routes to #new" do
      expect(:get => "/users/statics/new").to route_to("users/statics#new")
    end

    it "routes to #show" do
      expect(:get => "/users/statics/1").to route_to("users/statics#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/users/statics/1/edit").to route_to("users/statics#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/users/statics").to route_to("users/statics#create")
    end

    it "routes to #update" do
      expect(:put => "/users/statics/1").to route_to("users/statics#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/users/statics/1").to route_to("users/statics#destroy", :id => "1")
    end

  end
end
