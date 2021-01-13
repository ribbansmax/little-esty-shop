FactoryBot.define do
  factory :merchant do
    name {Faker::Name.name}

    trait :with_items do
      transient { items {1} }

      after(:create) do |merchant, evaluator|
        evaluator.items.times do
          create(:item, merchant: merchant)
        end
      end
    end
  end
end
