require 'rails_helper'

RSpec.describe "Users::Apis", :type => :request do
  describe "GET /users_apis" do
    it "works! (now write some real specs)" do
      get users_apis_path
      expect(response).to have_http_status(200)
    end
  end
end
