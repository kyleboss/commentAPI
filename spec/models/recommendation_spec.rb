describe Recommendation do
  let(:doctor) do
    doctor_obj = FactoryBot.build_stubbed(:doctor, latitude: 1, longitude: 2)
    allow(doctor_obj).to receive(:recent_average_rating) { 4 }
    doctor_obj
  end

  let(:recommended_doctor) do
    doctor_obj = FactoryBot.build_stubbed(:doctor)
    allow(doctor_obj).to receive(:distance_to).with(doctor) { 19 }
    allow(doctor_obj).to receive(:recent_average_rating) { 4 }
    doctor_obj
  end

  let(:recommendation) { FactoryBot.build(:recommendation, distance: 5, doctor: recommended_doctor) }

  describe '#initialize' do
    it 'is expected to set the distance instance variable' do
      expect(recommendation.instance_variable_get(:@distance)).to eq 5
    end

    it 'is expected to set the doctor instance variable' do
      expect(recommendation.instance_variable_get(:@doctor)).to eq recommended_doctor
    end
  end

  describe '.all_for' do
    before(:each) do
      expect(Recommendation).to receive(:doctors_close_to).with(doctor) { [recommended_doctor] }
      expect(Recommendation).to receive(:highly_rated_doctors).with([recommended_doctor]) { [recommended_doctor] }
      expect(Recommendation).to receive(:sort_doctors_by_score).with(doctor, [recommended_doctor]) do
        [recommended_doctor]
      end
    end

    it 'returns a list of recommended doctors' do
      expect(Recommendation.all_for(doctor).count).to eq 1
    end

    it 'returns a list of recommended doctors' do
      expect(Recommendation.all_for(doctor).first.doctor).to eq recommended_doctor
    end
  end

  describe '#as_json' do
    it 'returns a hash with average_rating' do
      expect(recommendation.as_json[:average_rating]).to eq 4
    end

    it 'returns a hash with distance' do
      expect(recommendation.as_json[:distance]).to eq 5
    end

    it 'returns a hash with name of the doctor' do
      expect(recommendation.as_json[:doctor_name]).to eq recommended_doctor.name
    end

    it 'returns a hash with of the doctor ID' do
      expect(recommendation.as_json[:doctor_id]).to eq recommended_doctor.id
    end
  end

  describe '.doctors_close_to' do
    before(:each) { expect(Doctor).to receive_message_chain(:by_distance, :limit) { [recommended_doctor] } }
    it 'returns the result of by_distance' do
      expect(Recommendation.send(:doctors_close_to, doctor)).to eq [recommended_doctor]
    end
  end

  describe '.highly_rated_doctors' do
    let(:doctor1) { FactoryBot.build_stubbed(:doctor) }
    let(:doctor2) { FactoryBot.build_stubbed(:doctor) }
    let(:doctor3) { FactoryBot.build_stubbed(:doctor) }

    before(:each) do
      expect(doctor1).to receive(:recent_average_rating) { 4 }
      expect(doctor2).to receive(:recent_average_rating) { 1 }
      expect(doctor3).to receive(:recent_average_rating) { 5 }
    end

    it 'filters out doctors whose average rating is not greater than 3' do
      expect(Recommendation.send(:highly_rated_doctors, [doctor1, doctor2, doctor3])).to eq [doctor1, doctor3]
    end
  end

  describe '.sort_doctors_by_score' do
    let(:base_doctor) { FactoryBot.build_stubbed(:doctor) }
    let(:doctor1) { FactoryBot.build_stubbed(:doctor) }
    let(:doctor2) { FactoryBot.build_stubbed(:doctor) }
    let(:doctor3) { FactoryBot.build_stubbed(:doctor) }

    context 'doctors is empty' do
      it 'returns an empty array' do
        expect(Recommendation.send(:sort_doctors_by_score, base_doctor, [])).to eq []
      end
    end

    context 'doctors is not empty' do
      subject { Recommendation.send(:sort_doctors_by_score, base_doctor, [doctor1, doctor2, doctor3]) }
      before(:each) do
        expect(doctor1).to receive(:distance_to).with(base_doctor) { 19 }
        expect(doctor2).to receive(:distance_to).with(base_doctor) { 22 }
        expect(doctor3).to receive(:distance_to).with(base_doctor) { 11 }
        expect(doctor1).to receive(:recent_average_rating) { 1 }
        expect(doctor2).to receive(:recent_average_rating) { 4 }
        expect(doctor3).to receive(:recent_average_rating) { 3 }
        expect(Recommendation).to receive(:recommendability_score).with(19, 11, 22, 1) { 5 }
        expect(Recommendation).to receive(:recommendability_score).with(22, 11, 22, 4) { 10 }
        expect(Recommendation).to receive(:recommendability_score).with(11, 11, 22, 3) { 2 }
      end

      it { is_expected.to eq [doctor2, doctor1, doctor3] }
    end
  end

  # Just going to put some values here to get a common-sense idea if the scores make sense.
  describe '.recommendability_score' do
    it 'calculates the recommendability score correctly by normalizing the distances to the rating' do
      expect(Recommendation.send(:recommendability_score, 20, 10, 30, 4)).to eq 6
      expect(Recommendation.send(:recommendability_score, 10, 10, 30, 5)).to eq 9
      expect(Recommendation.send(:recommendability_score, 30, 10, 30, 1)).to eq 1
    end
  end
end