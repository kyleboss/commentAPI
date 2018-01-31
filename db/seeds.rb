# frozen_string_literal: true

require 'factory_bot_rails'

# Doctor 1 is the base doctor. If you add a comment, the next best doctor in terms of both location & rating is Doctor
# 2, thus should be recommended. Followed by doctor 3, then doctor 4
FactoryBot.create(:doctor, name: 'Doctor 1', latitude: 37.792, longitude: -122.393)
doctor2 = FactoryBot.create(:doctor, name: 'Doctor 2', latitude: 36.792, longitude: -123.393)
doctor3 = FactoryBot.create(:doctor, name: 'Doctor 3', latitude: 35.792, longitude: -124.393)
doctor4 = FactoryBot.create(:doctor, name: 'Doctor 4', latitude: 34.792, longitude: -125.393)
FactoryBot.create(:comment, rating: 5, doctor: doctor2)
FactoryBot.create(:comment, rating: 3, doctor: doctor2)
FactoryBot.create(:comment, rating: 3, doctor: doctor3)
FactoryBot.create(:comment, rating: 3, doctor: doctor3)
FactoryBot.create(:comment, rating: 1, doctor: doctor4)
FactoryBot.create(:comment, rating: 2, doctor: doctor4)
