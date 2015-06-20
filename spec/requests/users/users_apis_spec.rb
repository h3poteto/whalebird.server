# coding: utf-8
require 'rails_helper'

RSpec.describe "Users::Apis", :type => :request do
  describe "GET /users_apis" do
    it "redirect to top" do
      get users_apis_path
      expect(response).to have_http_status(302)
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

    describe "read" do
      context "when count is empty" do
        before(:each) do
          @user.unread_count.unread = 0
          @user.unread_count.save!
        end
        it "should not decrement and not error" do
          post read_users_apis_path(format: :json)
          expect(response).to have_http_status(200)
          expect(@user.unread_count.unread).to eq(0)
        end
      end
      context "when count is 100" do
        before(:each) do
          @user.unread_count.unread = 100
          @user.unread_count.save!
        end
        it "should decrement" do
          post read_users_apis_path(format: :json)
          expect(response).to have_http_status(200)
          expect(@user.unread_count.unread).to eq(99)
        end
      end
    end
  end
end
