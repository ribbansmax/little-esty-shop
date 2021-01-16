require 'rails_helper'

RSpec.describe "Bulk Discount Index" do
  it "displays links to all discounts" do
    merchant = create(:merchant)
    create_list(:bulk_discount, 10, merchant: merchant)

    visit merchant_discounts_path(merchant)

    BulkDiscount.all.each do |discount|
      expect(page).to have_link("#{discount.discount * 100}% off", href: merchant_discount_path(merchant, discount))
    end
  end

  it "displays link to create new discount" do
    merchant = create(:merchant)
    visit merchant_discounts_path(merchant)

    expect(page).to have_link("New Discount", href: new_merchant_discount_path(merchant))
  end
end