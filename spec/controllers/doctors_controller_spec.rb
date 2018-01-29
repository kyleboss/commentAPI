# frozen_string_literal: true

describe DoctorsController do
  # This should return the minimal set of attributes required to create a valid
  # Doctor. As you add validations to Doctor, be sure to
  # adjust the attributes here as well.
  let(:group) { FactoryBot.create(:group) }
  let(:doctor) { FactoryBot.build_stubbed(:doctor, group: group) }
  let(:valid_attributes) do
    { name: doctor.name, street_address: doctor.street_address, zip_code: doctor.zip_code, city: doctor.city,
      state: doctor.state, latitude: doctor.latitude, longitude: doctor.longitude, group_id: group.id}
  end

  let(:invalid_attributes) { { name: nil } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DoctorsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      doctor = Doctor.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      doctor = Doctor.create! valid_attributes
      get :show, params: { id: doctor.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Doctor' do
        expect do
          post :create, params: { doctor: valid_attributes }, session: valid_session
        end.to change(Doctor, :count).by(1)
      end

      it 'renders a JSON response with the new doctor' do
        post :create, params: { doctor: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json')
        expect(response.location).to eq(doctor_url(Doctor.last))
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new doctor' do
        post :create, params: { doctor: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) { { name: 'Kyle' } }

      it 'updates the requested doctor' do
        doctor = Doctor.create! valid_attributes
        put :update, params: { id: doctor.to_param, doctor: new_attributes }, session: valid_session
        doctor.reload
        expect(doctor.name).to eq 'Kyle'
      end

      it 'renders a JSON response with the doctor' do
        doctor = Doctor.create! valid_attributes

        put :update, params: { id: doctor.to_param, doctor: valid_attributes }, session: valid_session
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json')
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the doctor' do
        doctor = Doctor.create! valid_attributes

        put :update, params: { id: doctor.to_param, doctor: invalid_attributes }, session: valid_session
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested doctor' do
      doctor = Doctor.create! valid_attributes
      expect do
        delete :destroy, params: { id: doctor.to_param }, session: valid_session
      end.to change(Doctor, :count).by(-1)
    end
  end
end
