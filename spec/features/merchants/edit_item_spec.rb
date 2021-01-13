require 'rails_helper'

RSpec.describe "Edit Item" do
  let(:item) {create(:item)}

  it "has a form pre-filled with the item's attributes" do
    visit edit_item_path(item)

    expect(page).to have_selector("input[value='#{item.name}']")
    expect(page).to have_selector("input[value='#{item.description}']")
    expect(page).to have_selector("input[value=#{item.unit_price}]")
  end

  it "edits the item's attributes" do
    visit edit_item_path(item)

    fill_in("item[name]", with: "New name")
    fill_in("item[description]", with: "New description")
    fill_in("item[unit_price]", with: 100)
    click_button("Update Item")

    expect(current_path).to eq(item_path(item))
    expect(page).to have_content("New name")
    expect(page).to have_content("Description: New description")
    expect(page).to have_content("Price: 100")
    expect(page).to have_content("Item has been updated!")
  end
end
