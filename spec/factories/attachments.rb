# == Schema Information
#
# Table name: attachments
#
#  id         :integer          not null, primary key
#  filename   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :attachment do
    filename File.open(File.join(Rails.root, 'app/assets/images/noimage.png'))
  end

end
