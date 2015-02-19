include Warden::Test::Helpers
module RequestHelpers
  def login(admin)
    login_as admin, scope: :admin
  end
end
