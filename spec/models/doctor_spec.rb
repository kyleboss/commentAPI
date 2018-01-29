# frozen_string_literal: true

describe Doctor do
  describe '#recent_average_rating' do
    let(:doctor) { FactoryBot.build_stubbed(:doctor) }
    before(:each) { expect(Comment).to receive(:recent_average_rating_for).with(doctor) { 3 } }
    it 'returns what Comment.recent_average_rating_for returns' do
      expect(doctor.recent_average_rating).to eq 3
    end
  end
end
