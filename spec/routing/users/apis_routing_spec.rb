require "rails_helper"

RSpec.describe Users::ApisController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/users/apis").to route_to("users/apis#index")
    end

    it "routes to #new" do
      expect(:get => "/users/apis/new").to route_to("users/apis#new")
    end

    it "routes to #show" do
      expect(:get => "/users/apis/1").to route_to("users/apis#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/users/apis/1/edit").to route_to("users/apis#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/users/apis").to route_to("users/apis#create")
    end

    it "routes to #update" do
      expect(:put => "/users/apis/1").to route_to("users/apis#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/users/apis/1").to route_to("users/apis#destroy", :id => "1")
    end

  end
end
