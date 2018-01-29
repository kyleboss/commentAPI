# frozen_string_literal: true

describe 'Comments' do
  describe 'GET /comments' do
    it do
      get comments_path
      expect(response).to be_successful
    end
  end

  describe 'PUT /deactivate/:comment_id' do
    it do
      comment = FactoryBot.create(:comment, is_active: true)
      put deactivate_comment_path(id: comment.id)
      expect(response).to be_successful
    end
  end
end
