# frozen_string_literal: true

describe SpecialtiesController do
  # This should return the minimal set of attributes required to create a valid
  # Specialty. As you add validations to Specialty, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { name: 'General' } }

  let(:invalid_attributes) { { name: nil } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # SpecialtiesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      specialty = Specialty.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      specialty = Specialty.create! valid_attributes
      get :show, params: { id: specialty.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Specialty' do
        expect do
          post :create, params: { specialty: valid_attributes }, session: valid_session
        end.to change(Specialty, :count).by(1)
      end

      it 'renders a JSON response with the new specialty' do
        post :create, params: { specialty: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(specialty_url(Specialty.last))
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new specialty' do
        post :create, params: { specialty: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { name: 'General2' } }

      it 'updates the requested specialty' do
        specialty = Specialty.create! valid_attributes
        put :update, params: { id: specialty.to_param, specialty: new_attributes }, session: valid_session
        specialty.reload
        expect(specialty.name).to eq 'General2'
      end

      it 'renders a JSON response with the specialty' do
        specialty = Specialty.create! valid_attributes

        put :update, params: { id: specialty.to_param, specialty: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the specialty' do
        specialty = Specialty.create! valid_attributes

        put :update, params: { id: specialty.to_param, specialty: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested specialty' do
      specialty = Specialty.create! valid_attributes
      expect do
        delete :destroy, params: { id: specialty.to_param }, session: valid_session
      end.to change(Specialty, :count).by(-1)
    end
  end
end
