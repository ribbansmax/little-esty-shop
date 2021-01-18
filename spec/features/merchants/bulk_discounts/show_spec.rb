require 'rails_helper'

RSpec.describe "Bulk Discount Index" do
  it "displays links to all discounts" do
    merchant = create(:merchant)
    discount = create(:bulk_discount, merchant: merchant)

    visit merchant_bulk_discount_path(merchant, discount)

    expect(page).to have_link("#{(discount.discount * 100).round(2)}% off", href: merchant_bulk_discount_path(merchant, discount))
  end
end