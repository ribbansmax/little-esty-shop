require 'rails_helper'

RSpec.describe "Bulk Discount Delete" do
  it "displays buttons to delete discounts" do
    merchant = create(:merchant)
    discount = create(:bulk_discount, merchant: merchant)

    visit merchant_bulk_discounts_path(merchant)

    expect(page).to have_content((discount.discount * 100).round(2))
    click_button "Delete"
    expect(page).not_to have_content((discount.discount * 100).round(2))
  end
end