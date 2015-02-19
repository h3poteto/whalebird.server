require 'rails_helper'

RSpec.describe Attachment, :type => :model do
  describe 'when migrate', :migration do
    # have db column
    it { should have_db_column(:id).of_type(:integer) }
    it { should have_db_column(:filename).of_type(:string) }
    it { should have_db_column(:created_at).of_type(:datetime) }
    it { should have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'when create', :create do
    context 'with valid atributes' do
      subject { build(:attachment) }
      it "should create a new instance" do
        expect(subject.save).not_to be_falsey
      end
    end
  end

  describe 'when delete', :create do
    subject { create(:attachment) }
    it "should delete" do
      id = subject.id
      expect(subject.destroy).not_to be_falsey
      expect { Attachment.find(id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
