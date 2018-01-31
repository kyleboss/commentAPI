# frozen_string_literal: true

describe Doctor do
  describe '#recent_average_rating' do
    let(:doctor) { FactoryBot.build_stubbed(:doctor) }
    before(:each) { allow(Comment).to receive(:recent_average_rating_for).with(doctor) { 3 } }
    context 'doctor has no comments' do
      it 'returns 0' do
        expect(doctor.recent_average_rating).to eq 0
      end
    end

    context 'doctor has comments' do
      let(:doctor) { FactoryBot.build_stubbed(:doctor, comments: [FactoryBot.build_stubbed(:comment)]) }
      it 'returns what Comment.recent_average_rating_for returns' do
        expect(doctor.recent_average_rating).to eq 3
      end
    end
  end
end
