# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null, indexed
#  uid                    :string(255)      default(""), not null, indexed => [provider]
#  provider               :string(255)      default(""), not null, indexed => [uid]
#  name                   :string(255)
#  screen_name            :string(255)
#  oauth_token            :string(255)
#  oauth_token_secret     :string(255)
#  userstream             :boolean          default(FALSE), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)      indexed
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#

module UsersHelper
end
