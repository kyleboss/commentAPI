# frozen_string_literal: true

describe 'Doctors' do
  describe 'GET /doctors' do
    it do
      get doctors_path
      expect(response).to be_successful
    end
  end
end
