require 'rails_helper'

RSpec.describe "Bulk Discount show" do
  it "displays discount info" do
    merchant = create(:merchant)
    discount = create(:bulk_discount, merchant: merchant)

    visit merchant_bulk_discount_path(merchant, discount)

    expect(page).to have_link("#{(discount.discount * 100).round(2)}% off", href: merchant_bulk_discount_path(merchant, discount))
    expect(page).to have_content(discount.threshold)
  end
end