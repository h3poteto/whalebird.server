require 'rails_helper'

RSpec.describe "Statics", :type => :request do
  describe "GET /statics" do
    it "works! (now write some real specs)" do
      get statics_path
      expect(response).to have_http_status(200)
    end
  end
end
