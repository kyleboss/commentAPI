# frozen_string_literal: true

describe Comment do
  describe '#recent_average_rating_for' do
    let!(:doctor1) { FactoryBot.create(:doctor) }
    let!(:doctor2) { FactoryBot.create(:doctor) }
    let!(:comment1) { FactoryBot.create(:comment, doctor: doctor1, rating: 1) }
    let!(:comment2) { FactoryBot.create(:comment, doctor: doctor1, rating: 3) }
    let!(:comment3) { FactoryBot.create(:comment, doctor: doctor2, rating: 5) }
    it 'averages the ratings of only the doctor that is passed in' do
      expect(Comment.recent_average_rating_for(doctor1)).to eq 2
    end
  end
end
