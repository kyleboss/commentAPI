# frozen_string_literal: true

describe CommentsController do
  # This should return the minimal set of attributes required to create a valid
  # Comment. As you add validations to Comment, be sure to
  # adjust the attributes here as well.
  let(:doctor) { FactoryBot.create(:doctor) }
  let(:author) { FactoryBot.create(:author) }
  let(:comment) { FactoryBot.build_stubbed(:comment, doctor: doctor, author: author) }
  let(:valid_attributes) do
    { doctor_id: doctor.id, body: comment.body, rating: comment.rating, author_id: author.id,
      is_active: comment.is_active }
  end
  let(:invalid_attributes) { { body: nil } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CommentsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      comment = Comment.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      comment = Comment.create! valid_attributes
      get :show, params: { id: comment.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Comment' do
        expect do
          post :create, params: { comment: valid_attributes }, session: valid_session
        end.to change(Comment, :count).by(1)
      end

      it 'renders a JSON response with the new comment' do
        post :create, params: { comment: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(comment_url(Comment.last))
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new comment' do
        post :create, params: { comment: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { body: 'HI!' } }

      it 'updates the requested comment' do
        comment = Comment.create! valid_attributes
        put :update, params: { id: comment.to_param, comment: new_attributes }, session: valid_session
        comment.reload
        expect(comment.body).to eq 'HI!'
      end

      it 'renders a JSON response with the comment' do
        comment = Comment.create! valid_attributes

        put :update, params: { id: comment.to_param, comment: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the comment' do
        comment = Comment.create! valid_attributes

        put :update, params: { id: comment.to_param, comment: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested comment' do
      comment = Comment.create! valid_attributes
      expect do
        delete :destroy, params: { id: comment.to_param }, session: valid_session
      end.to change(Comment, :count).by(-1)
    end
  end
end
