require 'rails_helper'

RSpec.describe "Bulk Discount edit page" do
  it "can edit the bulk discount" do
    merchant = create(:merchant)
    bulk_discount = create(:bulk_discount, merchant: merchant)
    visit merchant_bulk_discount_path(merchant, bulk_discount)

    expect(page).to have_link("#{bulk_discount.discount * 100}% off", href: merchant_bulk_discount_path(merchant, bulk_discount))

    click_button "edit"

    fill_in "bulk_discount[threshold]", with: 10
    fill_in "bulk_discount[discount]", with: 0.10

    click_button "commit"

    expect(current_path).to eq(merchant_bulk_discount_path(merchant, bulk_discount))

    expect(page).to have_link("10.0% off", href: merchant_bulk_discount_path(merchant, bulk_discount))

  end
end