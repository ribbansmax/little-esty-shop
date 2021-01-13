FactoryBot.define do
  factory :item, class: Item do
    name { Faker::Commerce.product_name }
    description { Faker::Quote.famous_last_words }
    unit_price { Faker::Number.between(from: 1, to: 100) }
    association :merchant

    trait :with_status do
      transient {status {0}}

      after(:create) do |item, transient|
        invoice = create(:invoice, :sequenced, merchant: item.merchant)
        create(:invoice_item, item: item, invoice: invoice, status: transient.status)
      end
    end
  end
end
