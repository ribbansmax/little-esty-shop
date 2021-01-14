FactoryBot.define do
  factory :customer, class: Customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    address { Faker::Address.full_address}

    trait :with_transactions do
      transient { merchant { create(:merchant)} }
      transient { successful {1}}
      transient { failed {1}}

      after(:create) do |customer, transient|
        transient.successful.times do
          create(:invoice,
                 :with_successful_transaction,
                 merchant: transient.merchant,
                 customer: customer)
        end
        transient.failed.times do
          create(:invoice,
                 :with_failed_transaction,
                  merchant: transient.merchant,
                  customer: customer)
        end
      end
    end
  end
end
