FactoryGirl.define do
  factory :user, aliases: [:pending_user] do
    transient do
      confirmed true
    end
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { "#{first_name}.#{last_name}@#{Faker::Internet.domain_name}" }
    username { "#{first_name}.#{last_name}" }
    phone_number { Faker::PhoneNumber.phone_number }
    password "please01"
    password_confirmation "please01"
    contactable true
    package_id 1
    unsubscribe_token { SecureRandom.uuid }

    after(:create) do |user, evaluator|
      user.confirm if evaluator.confirmed
    end
  end
end