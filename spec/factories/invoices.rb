FactoryBot.define do
  factory :invoice, class: Invoice do
    association :customer
    # association :merchant
    status {["in progress", "completed", "cancelled"].sample}

    trait :with_successful_transaction do
      after(:create) do |invoice|
        create(:transaction, invoice: invoice, result: 0)
      end
    end

    trait :with_failed_transaction do
      after(:create) do |invoice|
        create(:transaction, invoice: invoice, result: 1)
      end
    end

    trait :sequenced do
      sequence :created_at do |n|
        n.days
      end
    end

    factory :sequenced_successful_invoices, traits: [:sequenced, :with_successful_transaction]
  end
end
