require 'rails_helper'

RSpec.describe "Merchant Index" do
  it "displays links to all merchants" do
    create_list(:merchant, 10)

    visit merchants_path

    Merchant.all.each do |merchant|
      expect(page).to have_link(merchant.name, href: dashboard_merchant_path(merchant))
    end
  end
end