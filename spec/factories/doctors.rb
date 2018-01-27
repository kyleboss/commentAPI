FactoryBot.define do
  factory :doctor do
    name { Faker::Name.name }
    street_address { Faker::Address.street_address }
    zip_code { Faker::Address.zip_code }
    city { Faker::Address.city }
    state { Faker::Address.state }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    group
  end
end
