require 'rails_helper'

RSpec.describe "Users::Statics", :type => :request do
  describe "GET /users_statics" do
    it "works! (now write some real specs)" do
      get users_statics_path
      expect(response).to have_http_status(200)
    end
  end
end
