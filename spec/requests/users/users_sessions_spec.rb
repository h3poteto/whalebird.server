require 'rails_helper'

RSpec.describe "Users::Sessions", :type => :request do
  describe "can login" do
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

  describe "after login" do
    before(:each) do
      @user = create(:user_available)
      @client = Twitter::REST::Client.new do |config|
        config.consumer_key = ENV["TWITTER_CLIENT_ID"]
        config.consumer_secret = ENV["TWITTER_CLIENT_SECRET"]
        config.access_token = ENV["TWITTER_ACCESS_TOKEN"]
        config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
      end
      create(:user_setting_notification_on, user_id: @user.id)
      login_user @user
      Users::ApisController.skip_before_filter :check_application_key
    end
    context "when logout" do
      describe "should stop userstream" do
        it "should call stop userstream" do
          expect(@user.user_setting).to receive(:stop_userstream)
          delete destroy_user_session_path
        end
        it "should turn off notification" do
          delete destroy_user_session_path
          expect(@user.user_setting.notification?).to be_falsy
        end
      end
    end
  end
end
