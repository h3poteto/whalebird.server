# == Schema Information
#
# Table name: attachments
#
#  id         :integer          not null, primary key
#  filename   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Attachment < ActiveRecord::Base
  mount_uploader :filename, ImageUploader
end
