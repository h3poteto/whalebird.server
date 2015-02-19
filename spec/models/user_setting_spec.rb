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
end
