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
end