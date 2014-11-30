class Attachment < ActiveRecord::Base
  mount_uploader :filename, ImageUploader
end
