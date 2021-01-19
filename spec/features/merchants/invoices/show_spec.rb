require "rails_helper"

RSpec.describe "Merchant Invoices show" do
  describe "Displays" do
    it "invoices that have merchant's items" do
      merchant1 = create(:merchant)
      items = create_list(:item, 5, merchant: merchant1, unit_price: 1)

      invoice = create(:invoice)
      items.each do |item|
        create(:invoice_item, item: item, invoice: invoice, quantity: 5, unit_price: 1)
      end
      # create(:transaction, invoice: invoice, result: 0)

      visit merchant_invoice_path(merchant1, invoice)

      expect(page).to have_content(invoice.id)
      expect(page).to have_content(invoice.created_at.strftime("%A, %B %-d, %Y"))
      expect(page).to have_content(invoice.status)
    end
    it "customer info" do
      merchant1 = create(:merchant)
      items = create_list(:item, 5, merchant: merchant1, unit_price: 1)

      customer = create(:customer, first_name: "Linda", last_name: "Mayhew")

      invoice = create(:invoice, customer: customer)

      items.each do |item|
        create(:invoice_item, item: item, invoice: invoice, quantity: 5, unit_price: 1)
      end
      # create(:transaction, invoice: invoice, result: 0)

      visit merchant_invoice_path(merchant1, invoice)

      expect(page).to have_content("Linda Mayhew")
      expect(page).to have_content(customer.address)
    end
    it "invoice item information" do
      merchant1 = create(:merchant)
      items = create_list(:item, 5, merchant: merchant1, unit_price: 1)

      customer = create(:customer, first_name: "Linda", last_name: "Mayhew")

      invoice = create(:invoice, customer: customer)

      items.each do |item|
        create(:invoice_item, item: item, invoice: invoice, quantity: 5, unit_price: 1)
      end
      # create(:transaction, invoice: invoice, result: 0)

      visit merchant_invoice_path(merchant1, invoice)

      within "#item-information" do
        InvoiceItem.all.each do |invoice_item|
          expect(page).to have_content(invoice_item.item.name)
          expect(page).to have_content("quantity: #{invoice_item.quantity}")
          expect(page).to have_content("unit price: #{invoice_item.unit_price}")
        end
      end
    end
    it "can alter invoice_item status" do
      merchant1 = create(:merchant)
      items = create_list(:item, 5, merchant: merchant1, unit_price: 1)

      customer = create(:customer, first_name: "Linda", last_name: "Mayhew")

      invoice = create(:invoice, customer: customer)

      items.each do |item|
        create(:invoice_item, item: item, invoice: invoice, quantity: 5, unit_price: 1)
      end
      # create(:transaction, invoice: invoice, result: 0)

      visit merchant_invoice_path(merchant1, invoice)

      within "#item-information" do
        InvoiceItem.all.each do |invoice_item|
          within "#status-#{invoice_item.id}" do
            expect(page).to have_button("Update Item Status!")
            expect(page).to have_select("invoice_item[status]", selected: "#{invoice_item.status}")
            if invoice_item.status == "pending"
              select("packaged", from: "invoice_item[status]")
              click_button "Update Item Status!"
              expect(page).to have_select("invoice_item[status]", selected: "packaged")
            else
              select("pending", from: "invoice_item[status]")
              click_button "Update Item Status!"
              expect(page).to have_select("invoice_item[status]", selected: "pending")
            end
          end
        end
      end
    end
    it "total revenue" do
      merchant1 = create(:merchant)
      items = create_list(:item, 5, merchant: merchant1, unit_price: 1)

      customer = create(:customer, first_name: "Linda", last_name: "Mayhew")

      invoice = create(:invoice, customer: customer)

      items.each do |item|
        create(:invoice_item, item: item, invoice: invoice, quantity: 5, unit_price: 1)
      end
      # create(:transaction, invoice: invoice, result: 0)

      visit merchant_invoice_path(merchant1, invoice)

      expect(page).to have_content("Total Revenue: $#{invoice.invoice_amount}")
    end

    it "links to bulk_discounts used on invoice_items" do
      merchant1 = create(:merchant)
      items = create_list(:item, 5, merchant: merchant1, unit_price: 100)
      customer = create(:customer, first_name: "Linda", last_name: "Mayhew")
      bulk_discount = create(:bulk_discount, merchant: merchant1, threshold: 4, discount: 0.50)
      invoice = create(:invoice, customer: customer)

      items.each_with_index do |item, index|
        create(:invoice_item, item: item, invoice: invoice, quantity: index + 1)
      end

      visit merchant_invoice_path(merchant1, invoice)

      within "#item-information" do
        expect(page).to have_link("Discount", href: merchant_bulk_discount_path(merchant1, bulk_discount))
      end
    end
  end
end
