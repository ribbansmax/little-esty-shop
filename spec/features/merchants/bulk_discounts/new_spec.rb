require 'rails_helper'

RSpec.describe "Bulk Discount New page" do
  it "can create a new discount" do
    merchant = create(:merchant)

    visit new_merchant_bulk_discount_path(merchant)

    fill_in "bulk_discount[threshold]", with: 10
    fill_in "bulk_discount[discount]", with: 10

    click_button "commit"

    expect(current_path).to eq(merchant_bulk_discounts_path(merchant))
  end

  it "can detect when a new discount has not been created with values" do
    merchant = create(:merchant)

    visit new_merchant_bulk_discount_path(merchant)

    fill_in "bulk_discount[discount]", with: 10

    click_button "commit"

    expect(current_path).to eq(new_merchant_bulk_discount_path(merchant))
    expect(page).to have_content("Threshold can't be blank")

    fill_in "bulk_discount[threshold]", with: 10

    click_button "commit"

    expect(current_path).to eq(new_merchant_bulk_discount_path(merchant))
    expect(page).to have_content("Discount can't be blank")
  end
end