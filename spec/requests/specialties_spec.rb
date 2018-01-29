# frozen_string_literal: true

describe 'Specialties' do
  describe 'GET /specialties' do
    it do
      get specialties_path
      expect(response).to be_successful
    end
  end
end
