require 'rails_helper'

RSpec.describe "Users::Apis", :type => :request do
  describe "GET /users_apis" do
    it "redirect to top" do
      get users_apis_path
      expect(response).to have_http_status(302)
    end
  end

  describe "should can login" do
    before(:each) do
      Users::SessionsController.skip_before_filter :check_application_key
    end
    it "should access sign_in" do
      get new_user_session_path
      expect(response).to have_http_status(200)
    end
    context "with twitter" do
      let(:user) { create(:user) }
      let(:oauth_user) { set_omniauth(user) }
      it "should redirect to twitter" do
        post user_omniauth_authorize_path(:twitter)
        expect(response).to have_http_status(302)
        expect(response.header["Location"]).to include("https://api.twitter.com/oauth/authenticate")
      end
    end
  end
end
