FactoryBot.define do
  factory :recommendation do
    doctor
    distance { Faker::Number.number }
    initialize_with { new(distance, doctor) }
  end
end
