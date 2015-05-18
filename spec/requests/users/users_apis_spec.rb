# coding: utf-8
require 'rails_helper'

RSpec.describe "Users::Apis", :type => :request do
  describe "GET /users_apis" do
    it "redirect to top" do
      get users_apis_path
      expect(response).to have_http_status(302)
    end
  end

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
      unread_count = create(:unread_count)
      @user.unread_count = unread_count
      @user.save
      login_user @user
      Users::ApisController.skip_before_filter :check_application_key
    end
    describe "can get user timeline" do
      it "healthy response" do
        get user_timeline_users_apis_path(format: :json, params: {"q"=>"送信済みツイート", "screen_name"=>"h3_poteto", "settings"=>{"count"=>"50"}})
        expect(response).to be_success
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json.length).to eq(50)
        if json.first["retweeted"].blank?
          expect(json.first["user"]["screen_name"]).to eq(@user.screen_name)
        else
          expect(json.first["retweeted"]["screen_name"]).to eq(@user.screen_name)
        end
      end
    end

    describe "start userstream" do
      describe "when update" do
        before(:each) { UserSetting.skip_callback(:create, :after, :start_userstream) }
        let(:user_setting_params) { attributes_for(:user_setting_notification_on, user_id: @user.id) }
        let!(:user_setting) { create(:user_setting, user_setting_params) }
        context "when userstream is not running" do
          before(:each) do
            @user.update_attributes!(userstream: false)
          end
          context "change settings" do
            it "should start userstream" do
              new_params = attributes_for(:user_setting_notification_off, user_id: @user.id)
              post update_settings_users_apis_path(format: :json, params: {settings: new_params})
              expect(response).to have_http_status(200)
              expect(@user.userstream?).to be_truthy
            end
          end
          context "do not change settings" do
            it "should start userstream" do
              post update_settings_users_apis_path(format: :json, params: {settings: user_setting_params})
              expect(response).to have_http_status(200)
              expect(@user.userstream?).to be_truthy
            end
          end
        end
      end
    end
  end
end
