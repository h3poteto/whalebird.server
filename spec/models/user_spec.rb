require 'rails_helper'

RSpec.describe User, :type => :model do
  describe 'when migrate', :migration do
    # association
    it { should have_one(:user_setting) }
    it { should have_one(:unread_count) }

    # have db column
    it { should have_db_column(:id).of_type(:integer) }
    it { should have_db_column(:email).of_type(:string).with_options(null:false, default:'') }
    it { should have_db_column(:uid).of_type(:string).with_options(null:false, default:'') }
    it { should have_db_column(:provider).of_type(:string).with_options(null:false, default:'') }
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_column(:screen_name).of_type(:string) }
    it { should have_db_column(:oauth_token).of_type(:string) }
    it { should have_db_column(:oauth_token_secret).of_type(:string) }
    it { should have_db_column(:encrypted_password).of_type(:string).with_options(null:false, default:'') }
    it { should have_db_column(:reset_password_token).of_type(:string) }
    it { should have_db_column(:reset_password_sent_at).of_type(:datetime) }
    it { should have_db_column(:remember_created_at).of_type(:datetime) }
    it { should have_db_column(:sign_in_count).of_type(:integer).with_options(default: 0) }
    it { should have_db_column(:current_sign_in_at).of_type(:datetime) }
    it { should have_db_column(:last_sign_in_at).of_type(:datetime) }
    it { should have_db_column(:current_sign_in_ip).of_type(:string) }
    it { should have_db_column(:last_sign_in_ip).of_type(:string) }
    it { should have_db_column(:created_at).of_type(:datetime) }
    it { should have_db_column(:updated_at).of_type(:datetime) }

    # index
    it { should have_db_index(:email).unique(true) }
    it { should have_db_index(:reset_password_token).unique(true) }
  end

  describe 'when create' do
    context 'with valid attributes' do
      subject { build(:user) }
      it "should create a new instance" do
        expect(subject.save).not_to be_falsey
      end
    end

    describe "create unread" do
      let!(:user) { create(:user) }
      it "should exist unread" do
        expect(user.unread_count.present?).to be_truthy
        expect(user.unread_count.unread).to eq(0)
      end
    end
  end

  describe 'when update' do
    context 'after create' do
      before do
        @attr = attributes_for(:user)
        @user = create(:user)
        @user.update_attributes(@attr)
      end
      subject { User.find(@user.id) }
      it "should new values" do
        @attr.each do |k,v|
          expect(subject.send(k)).to eq(v) unless k == :password
        end
      end
    end
  end

  describe 'when delete', :delete do
    subject { create(:user) }
    it "should delete" do
      id = subject.id
      expect(subject.destroy).not_to be_falsey
      expect { User.find(id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
