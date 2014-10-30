require "rails_helper"

RSpec.describe StaticsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/statics").to route_to("statics#index")
    end

    it "routes to #new" do
      expect(:get => "/statics/new").to route_to("statics#new")
    end

    it "routes to #show" do
      expect(:get => "/statics/1").to route_to("statics#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/statics/1/edit").to route_to("statics#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/statics").to route_to("statics#create")
    end

    it "routes to #update" do
      expect(:put => "/statics/1").to route_to("statics#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/statics/1").to route_to("statics#destroy", :id => "1")
    end

  end
end
