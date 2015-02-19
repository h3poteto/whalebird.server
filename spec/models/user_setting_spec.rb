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

  describe 'when create' do
    before(:each) { UserSetting.skip_callback(:create, :after, :start_userstream) }
    context 'with valid attributes' do
      subject { build(:user_setting) }
      it "should create a new instance" do
        expect(subject.save).not_to be_falsey
      end
    end
  end

  describe 'when update' do
    before(:each) { UserSetting.skip_callback(:update, :before, :start_userstream) }
    before(:each) { UserSetting.skip_callback(:create, :after, :start_userstream) }
    context 'after create' do
      before do
        @attr = attributes_for(:user_setting)
        @user_setting = create(:user_setting)
        @user_setting.update_attributes(@attr)
      end
      subject { UserSetting.find(@user_setting.id) }
      it "should new values" do
        @attr.each do |k,v|
          expect(subject.send(k)).to eq(v)
        end
      end
    end

    context 'notification on' do
      before { @user_setting = create(:user_setting_notification_off) }
      it "should be true" do
        @user_setting.notification = true
        expect(@user_setting.activate_notification?).to be_truthy
      end
    end

    context 'notification off' do
      before { @user_setting = create(:user_setting_notification_on) }
      it "should be false" do
        @user_setting.notification = false
        expect(@user_setting.activate_notification?).to be_falsey
      end
    end
  end

  describe 'when delete', :delete do
    subject { create(:user_setting) }
    it "should delete" do
      id = subject.id
      expect(subject.destroy).not_to be_falsey
      expect { UserSetting.find(id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
