require 'rails_helper'

RSpec.describe UnreadCount, :type => :model do
  describe 'when migrate', :migration do
    # association
    it { should belong_to(:user) }

    # have db column
    it { should have_db_column(:id).of_type(:integer) }
    it { should have_db_column(:user_id).of_type(:integer) }
    it { should have_db_column(:unread).of_type(:integer).with_options(null:false, default: 0) }
    it { should have_db_column(:created_at).of_type(:datetime) }
    it { should have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'when create' do
    context 'with valid attributes' do
      subject { build(:unread_count) }
      it "should create a new instance" do
        expect(subject.save).not_to be_falsey
      end
    end
  end

  describe 'when update' do
    context 'after create' do
      before do
        @attr = attributes_for(:unread_count)
        @unread_count = create(:unread_count)
        @unread_count.update_attributes(@attr)
      end
      subject { UnreadCount.find(@unread_count.id) }
      it "should new values" do
        @attr.each do |k,v|
          expect(subject.send(k)).to eq(v)
        end
      end
    end
  end

  describe 'when delete', :delete do
    subject { create(:unread_count) }
    it "should delete" do
      id = subject.id
      expect(subject.destroy).not_to be_falsey
      expect { UnreadCount.find(id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "decrement" do
    before do
      @user = create(:user)
    end
    context "when unread is 100" do
      before do
        @user.unread_count.unread = 100
        @user.unread_count.save!
      end
      it "shoud decrement" do
        expect{ @user.unread_count.decrement }.to change{ @user.unread_count.unread }.from(100).to(99)
      end
    end
    context "when unread is 0" do
      it "should not decrement" do
        expect{ @user.unread_count.decrement }.not_to change{ @user.unread_count.unread }
      end
    end
  end
end
