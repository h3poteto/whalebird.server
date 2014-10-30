class Users::RegistrationsController < ApplicationController

  def build_resource(hash=nil)
    hash[:uid] = User.create_unique_string
    super
  end
end
