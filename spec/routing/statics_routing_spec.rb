require "rails_helper"

RSpec.describe StaticsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/statics").to route_to("statics#index")
      expect(:get => "/").to route_to("statics#index")
    end

    it "routes to #new" do
      expect(:get => "/statics/new").not_to be_routable
    end

    it "routes to #show" do
      expect(:get => "/statics/1").not_to be_routable
    end

    it "routes to #edit" do
      expect(:get => "/statics/1/edit").not_to be_routable
    end

    it "routes to #create" do
      expect(:post => "/statics").not_to be_routable
    end

    it "routes to #update" do
      expect(:put => "/statics/1").not_to be_routable
    end

    it "routes to #destroy" do
      expect(:delete => "/statics/1").not_to be_routable
    end

  end
end
