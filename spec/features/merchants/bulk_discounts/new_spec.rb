require 'rails_helper'

RSpec.describe "Bulk Discount New page" do
  it "displays links to all discounts" do
    merchant = create(:merchant)

    visit new_merchant_bulk_discount_path(merchant)

    fill_in "bulk_discount[threshold]", with: 10
    fill_in "bulk_discount[discount]", with: 10

    click_button "commit"

    expect(current_path).to eq(merchant_bulk_discounts_path(merchant))
  end
end