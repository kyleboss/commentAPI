FactoryBot.define do
  factory :comment do
    body { Faker::RuPaul.quote }
    rating { Faker::Number.between(1, 5) }
    is_active true
    doctor
    author
  end

  factory :inactive_comment, parent: :comment do
    is_active false
  end
end
