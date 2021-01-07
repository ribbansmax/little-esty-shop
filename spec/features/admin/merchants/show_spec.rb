require 'rails_helper'

describe "Admin Merchants Show Page" do
  before :each do
    @merchant = create(:merchant)
    visit admin_merchant_path(@merchant.id)
  end

  it "has the merchant's name displayed on the page" do
    expect(page).to have_content(@merchant.name)
  end
end
