FactoryBot.define do
  factory :item, class: Item do
    name { Faker::Commerce.product_name }
    description { Faker::Quote.famous_last_words }
    unit_price { Faker::Number.between(from: 1, to: 100) }
    association :merchant

    trait :with_status do
      transient {status {0}}

      after(:create) do |item, transient|
        invoice = create(:invoice, :sequenced)
        create(:invoice_item, item: item, invoice: invoice, status: transient.status)
      end
    end

    trait :sold do
      unit_price { 1 }
      transient { sales {1}}
      transient { invoice_date { 1.month.ago }}

      after(:create) do |item, transient|
        transient.sales.times do
          invoice = create(:sequenced_successful_invoices, created_at: transient.invoice_date)
          create(:invoice_item, item: item, invoice: invoice, quantity: 1).update(unit_price: 1)
        end
      end
    end

    trait :failed_sales do
      after(:create) do |item|
        invoice = create(:invoice, :with_failed_transaction)
        create(:invoice_item, item: item, invoice: invoice, unit_price: 1, quantity: 1)
      end
    end
  end
end
