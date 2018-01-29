# frozen_string_literal: true

describe 'Authors' do
  describe 'GET /authors' do
    it do
      get authors_path
      expect(response).to be_successful
    end
  end
end
