require 'rails_helper'

RSpec.describe "Specialties", type: :request do
  describe "GET /specialties" do
    it "works! (now write some real specs)" do
      get specialties_path
      expect(response).to have_http_status(200)
    end
  end
end
