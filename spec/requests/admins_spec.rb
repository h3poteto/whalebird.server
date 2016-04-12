require 'rails_helper'

RSpec.describe "Admins", :type => :request do
  describe "after login" do
    let(:admin) { create(:admin) }
    before do
      login admin
      visit sidekiq_web_path
    end
    describe "should sidekiq page" do
      it { expect(has_title?("Sidekiq")).to be_truthy }
    end
  end
end
