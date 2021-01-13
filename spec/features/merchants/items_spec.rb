require 'rails_helper'

RSpec.describe "Items Index" do
  let(:merchant) {create(:merchant)}

  describe 'displays' do
    it "merchant's items" do
      merchant1 = create(:merchant)
      item1 = create(:item, merchant: merchant1)
      merchant2 = create(:merchant)
      item2 = create(:item, merchant: merchant2)

      visit merchant_items_path(merchant1)

      expect(page).to have_link(item1.name, href: item_path(item1))
      expect(page).not_to have_content(item2.name)
    end

    it "link to create new item" do
      visit merchant_items_path(merchant)

      expect(page).to have_link("New Item", href: new_merchant_item_path(merchant))
    end
  end

  describe 'section for' do
    describe "top items" do
      let!(:top_items) {[
        create(:item, :sold, merchant: merchant, sales: 6),
        create(:item, :sold, merchant: merchant, sales: 5),
        create(:item, :sold, merchant: merchant, sales: 4),
        create(:item, :sold, merchant: merchant, sales: 3),
        create(:item, :sold, merchant: merchant, sales: 2)
      ]}

      it "displays the 5 most popular items" do
        not_top = create(:item, :sold, merchant: merchant, sales: 1)

        visit merchant_items_path(merchant)

        within '#top_items' do
          expect(page).not_to have_content(not_top.name)
          top_items.each_with_index do |item, index|
            within "#top-#{item.id}" do
              expect(page).to have_link(item.name, href: item_path(item))
              expect(page).to have_content("$ #{6 - index}")
            end
          end
        end
      end

      it "does not include items without at least one successful transaction" do
        not_top = create(:item, :failed_sales, merchant: merchant, unit_price: 1000)

        visit merchant_items_path(merchant)

        within '#top_items' do
          expect(page).not_to have_content(not_top.name)
        end
      end

      it "uses the unit price from the invoice_item rather than the invoice" do
        not_top = create(:item, :sold, merchant: merchant, sales: 1, unit_price: 1000)

        visit merchant_items_path(merchant)

        within '#top_items' do
          expect(page).not_to have_content(not_top.name)
        end
      end

      it "shows items in order of total revenue" do
        visit merchant_items_path(merchant)

        within '#top_items' do
          expect(top_items[0].name).to appear_before(top_items[1].name)
          expect(top_items[1].name).to appear_before(top_items[2].name)
          expect(top_items[2].name).to appear_before(top_items[3].name)
          expect(top_items[3].name).to appear_before(top_items[4].name)
        end
      end

      it "with their best sales day" do
        visit merchant_items_path(merchant)

        within("#top_items") do
          top_items.each do |item|
            top_day = item.invoices.last.created_at.strftime("%A, %B %-d, %Y")
            expect(page).to have_content("Top selling date for #{item.name} was #{top_day}")
          end
        end
      end

      it "shows the most recent day if multiple days have the top sales" do
        top_items = create_list(:item, 5, :sold, merchant: merchant, invoice_date: Date.today, sales: 7)

        visit merchant_items_path(merchant)

        within("#top_items") do
          top_items.each do |item|
            top_day = Date.today.strftime("%A, %B %-d, %Y")
            expect(page).to have_content("Top selling date for #{item.name} was #{top_day}")
          end
        end
      end
    end
  end

  describe "lists enabled/disabled items" do
    it "grouped by status" do
      enabled_item = create(:item, merchant: merchant)
      disabled_item = create(:item, merchant: merchant, enabled: false)

      visit merchant_items_path(merchant)

      expect(page).to have_content("Enabled Items")
      within("#enabled") {expect(page).to have_content(enabled_item.name)}
      expect(page).to have_content("Disabled Items")
      within("#disabled") {expect(page).to have_content(disabled_item.name)}
    end

   it 'with buttons to disable/enable items' do
      item = create(:item, merchant: merchant)

      visit merchant_items_path(merchant)

      within "#enabled" do
        expect(page).to have_button("Disable")
        expect(page).to have_content(item.name)
        click_button "Disable"
        expect(current_path).to eq(merchant_items_path(merchant))
        expect(page).not_to have_content(item.name)
      end

      within "#disabled" do
        expect(page).to have_button("Enable")
        expect(page).to have_content(item.name)
        click_button "Enable"
        expect(current_path).to eq(merchant_items_path(merchant))
        expect(page).not_to have_content(item.name)
      end

      within "#enabled" do
        expect(page).to have_content(item.name)
      end
    end
  end
end
