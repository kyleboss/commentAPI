require 'rails_helper'

RSpec.describe "DoctorsSpecialties", type: :request do
  describe "GET /doctors_specialties" do
    it "works! (now write some real specs)" do
      get doctors_specialties_path
      expect(response).to have_http_status(200)
    end
  end
end
