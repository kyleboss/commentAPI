# frozen_string_literal: true

describe GroupsController do
  # This should return the minimal set of attributes required to create a valid
  # Group. As you add validations to Group, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { } }

  let(:invalid_attributes) { { } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # GroupsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      group = Group.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      group = Group.create! valid_attributes
      get :show, params: { id: group.to_param }, session: valid_session
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Group' do
        expect do
          post :create, params: { group: valid_attributes }, session: valid_session
        end.to change(Group, :count).by(1)
      end

      it 'renders a JSON response with the new group' do
        post :create, params: { group: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(group_url(Group.last))
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { } }

      it 'renders a JSON response with the group' do
        group = Group.create! valid_attributes

        put :update, params: { id: group.to_param, group: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested group' do
      group = Group.create! valid_attributes
      expect do
        delete :destroy, params: { id: group.to_param }, session: valid_session
      end.to change(Group, :count).by(-1)
    end
  end
end
