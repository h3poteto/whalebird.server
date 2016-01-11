require 'rails_helper'

RSpec.describe UserSetting, :type => :model do
  describe 'when migrate', :migration do
    # association
    it { should belong_to(:user) }

    # have db column
    it { should have_db_column(:id).of_type(:integer) }
    it { should have_db_column(:notification).of_type(:boolean).with_options(null:false, default: true) }
    it { should have_db_column(:reply).of_type(:boolean).with_options(null:false, default: true) }
    it { should have_db_column(:favorite).of_type(:boolean).with_options(null:false, default: true) }
    it { should have_db_column(:direct_message).of_type(:boolean).with_options(null:false, default: true) }
    it { should have_db_column(:retweet).of_type(:boolean).with_options(null:false, default: true) }
    it { should have_db_column(:device_token).of_type(:string) }
    it { should have_db_column(:created_at).of_type(:datetime) }
    it { should have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'when validate', :validation do
    # presence of
    it { should validate_presence_of(:user_id) }
  end

  describe 'start_userstream' do
    context 'when create' do
      context "user_setting notification is true" do
        let(:user_setting) { build(:user_setting_notification_on) }
        it "should call start_userstream" do
          expect(user_setting).to receive(:start_userstream)
          user_setting.save!
        end
      end

      context "user_setting notification is false" do
        let(:user_setting) { build(:user_setting_notification_off) }
        it "should call start_userstream" do
          expect(user_setting).to receive(:start_userstream)
          user_setting.save!
        end
      end
    end

    context 'when update' do
      let(:user) { create(:user) }
      let(:user_setting) { create(:user_setting_notification_on, user_id: user.id) }
      context "when userstream is not running" do
        before(:each) do
          user.update_attributes!(userstream: false)
        end
        context "change settings" do
          it "should call start_userstream" do
            expect(user_setting).not_to receive(:start_userstream)
            user_setting.notification = false
            user_setting.save!
            expect(user.reload.userstream).to be_truthy
          end
        end
        context "do not change settings" do
          it "should call start_userstream" do
            expect(user_setting).not_to receive(:start_userstream)
            user_setting.save!
            expect(user.reload.userstream).to be_truthy
          end
        end
      end

      context "when userstream is running" do
        before(:each) do
          user.update_attributes!(userstream: true)
        end
        context "change settings" do
          it "should not call start_userstream" do
            user_setting.notification = false
            expect(user_setting).not_to receive(:start_userstream)
            user_setting.save!
            expect(user.reload.userstream).to be_truthy
          end
        end
        context "do not change settings" do
          it "should not call start_userstream" do
            expect(user_setting).not_to receive(:start_userstream)
            user_setting.save!
            expect(user.reload.userstream).to be_truthy
          end
        end
      end
    end
  end
end
