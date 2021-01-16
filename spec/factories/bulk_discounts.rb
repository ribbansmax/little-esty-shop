FactoryBot.define do
  factory :bulk_discount do
    threshold { Faker::Number.within(range: 5..20) }
    discount { Faker::Number.decimal(l_digits: 0, r_digits: 2) }
  end
end
