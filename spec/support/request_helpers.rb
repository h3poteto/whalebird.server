include Warden::Test::Helpers
module RequestHelpers
  def login(admin)
    login_as admin, scope: :admin
  end

  def login_user(user)
    login_as user, scope: :user
  end

  def set_omniauth(user)
    OmniAuth.config.test_mode = true

    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
      {
        provider: 'twitter',
        uid: user.uid
      }
    )
    OmniAuth.config.add_mock(
      "twitter",
      { info: {
          screen_name: user.screen_name
        }
      }
    )

    OmniAuth.config.mock_auth[:twitter]
  end
end
