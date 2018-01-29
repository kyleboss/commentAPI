# frozen_string_literal: true

describe 'DoctorsSpecialties' do
  describe 'GET /doctors_specialties' do
    it do
      get doctors_specialties_path
      expect(response).to be_successful
    end
  end
end
