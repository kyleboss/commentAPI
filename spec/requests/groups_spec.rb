# frozen_string_literal: true

describe 'Groups' do
  describe 'GET /groups' do
    it do
      get groups_path
      expect(response).to be_successful
    end
  end
end
