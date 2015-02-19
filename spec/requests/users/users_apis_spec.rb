require 'rails_helper'

RSpec.describe "Users::Apis", :type => :request do
  describe "GET /users_apis" do
    it "redirect to top" do
      get users_apis_path
      expect(response).to have_http_status(302)
    end
  end
end
