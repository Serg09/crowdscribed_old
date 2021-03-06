FactoryGirl.define do
  factory :fulfillment do
    contribution
    reward
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    delivered false

    factory :electronic_fulfillment do
      type 'ElectronicFulfillment'
      email { Faker::Internet.email }
    end

    factory :physical_fulfillment do
      type 'PhysicalFulfillment'
      address1  { Faker::Address.street_address }
      address2 { Faker::Address.secondary_address }
      city { Faker::Address.city }
      state { Faker::Address.state_abbr }
      postal_code { Faker::Address.postcode }
      country_code 'US'
    end
  end
end
