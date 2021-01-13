require 'rails_helper'

RSpec.describe "New Item" do
  let(:merchant) {create(:merchant)}

  it "creates a new item" do
    visit new_merchant_item_path(merchant)

    fill_in("item[name]", with: "LOUD ONION")
    fill_in("item[description]", with: "makes u cry")
    fill_in("item[unit_price]", with: 100)
    click_button("Create")

    expect(current_path).to eq(merchant_items_path(merchant))
    expect(page).to have_content("LOUD ONION")
    expect(page).to have_button("Enable")
  end

  it "does not allow creation of incomplete items" do
    visit new_merchant_item_path(merchant)

    click_button("Create")

    expect(page).to have_content("Name can't be blank")
    expect(page).to have_content("Description can't be blank")
    expect(page).to have_content("Unit price can't be blank")
  end
end
