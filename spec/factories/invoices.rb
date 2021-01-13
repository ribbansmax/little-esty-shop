FactoryBot.define do
  factory :invoice, class: Invoice do
    association :customer
    association :merchant
    status {["in progress", "completed", "cancelled"].sample}
  end

  # trait :with_items do
  #   transient { items {1} }
  #
  #   after(:create) do |invoice, evaluator|
  #     evaluator.items.times do
  #       item = create(:item, merchant_id: invoice.merchant_id)
  #       create(:invoice_item, invoice: invoice, item: item)
  #     end
  #   end
  # end
  
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
end
