# frozen_string_literal: true

describe AuthorsController do
  # This should return the minimal set of attributes required to create a valid
  # Author. As you add validations to Author, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { name: 'Kyle' } }
  let(:invalid_attributes) { { name: nil } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AuthorsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      author = Author.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      author = Author.create! valid_attributes
      get :show, params: { id: author.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Author' do
        expect do
          post :create, params: { author: valid_attributes }, session: valid_session
        end.to change(Author, :count).by(1)
      end

      it 'renders a JSON response with the new author' do
        post :create, params: { author: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(author_url(Author.last))
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new author' do
        post :create, params: { author: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { name: 'Bobby' } }

      it 'updates the requested author' do
        author = Author.create! valid_attributes
        put :update, params: { id: author.to_param, author: new_attributes }, session: valid_session
        author.reload
        expect(author.name).to eq 'Bobby'
      end

      it 'renders a JSON response with the author' do
        author = Author.create! valid_attributes

        put :update, params: { id: author.to_param, author: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the author' do
        author = Author.create! valid_attributes

        put :update, params: { id: author.to_param, author: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested author' do
      author = Author.create! valid_attributes
      expect do
        delete :destroy, params: { id: author.to_param }, session: valid_session
      end.to change(Author, :count).by(-1)
    end
  end
end
