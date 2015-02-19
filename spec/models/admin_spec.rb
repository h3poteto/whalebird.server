require 'rails_helper'

RSpec.describe Admin, :type => :model do
  describe 'when migrate', :migration do
    # have db column
    it { should have_db_column(:id).of_type(:integer) }
    it { should have_db_column(:email).of_type(:string).with_options(null:false, default:'') }
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
      subject { build(:admin) }
      it "should create a new instance" do
        expect(subject.save).not_to be_falsey
      end
    end
  end

  describe 'when update' do
    context 'after create' do
      before do
        @attr = attributes_for(:admin)
        @admin = create(:admin)
        @admin.update_attributes(@attr)
      end
      subject { Admin.find(@admin.id) }
      it "should new values" do
        @attr.each do |k,v|
          expect(subject.send(k)).to eq(v) unless k == :password
        end
      end
    end
  end

  describe 'when delete', :delete do
    subject { create(:admin) }
    it "should delete" do
      id = subject.id
      expect(subject.destroy).not_to be_falsey
      expect { Admin.find(id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
