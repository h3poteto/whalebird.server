require 'rails_helper'

RSpec.describe "Statics", :type => :request do
  describe "GET /statics" do
    it "works!" do
      get statics_path
      expect(response).to have_http_status(200)
    end
  end
end
