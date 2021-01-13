require "rails_helper"

RSpec.describe "Merchant Dashboard" do
  let(:merchant) {create(:merchant)}

  describe "displays" do
    it "the merchant name" do
      visit dashboard_merchant_path(merchant)

      expect(page).to have_content(merchant.name)
    end

    it "link to merchant's item index" do
      visit dashboard_merchant_path(merchant)

      click_link "My Items"

      expect(current_path).to eq(merchant_items_path(merchant))
    end

    it "link to merchant's invoices index" do
      visit dashboard_merchant_path(merchant)

      click_link "My Invoices"

      expect(current_path).to eq(merchant_invoices_path(merchant))
    end
  end

  describe "has section for" do
    describe "Favorite Customers" do
      let!(:merchant) {create(:merchant)}
      let!(:top_customers)  {[
          create(:customer, :with_transactions, successful: 6, merchant: merchant),
          create(:customer, :with_transactions, successful: 5, merchant: merchant),
          create(:customer, :with_transactions, successful: 4, merchant: merchant),
          create(:customer, :with_transactions, successful: 3, merchant: merchant),
          create(:customer, :with_transactions, successful: 2, merchant: merchant),
        ]}

      it "listing the top 5 customers, with purchase counts, in order" do
        not_top = create(:customer, :with_transactions, successful: 1, merchant: merchant)

        visit dashboard_merchant_path(merchant)

        expect(page).not_to have_content("#{not_top.first_name} #{not_top.last_name}")
        within "#favorite_customers" do
          top_customers.each_with_index do |customer, index|
            expect(page).to have_content("#{customer.first_name} #{customer.last_name}")
            expect(page).to have_content("#{6 - index} purchase(s)")
          end
          expect(top_customers[0].last_name).to appear_before(top_customers[1].last_name)
          expect(top_customers[1].last_name).to appear_before(top_customers[2].last_name)
          expect(top_customers[2].last_name).to appear_before(top_customers[3].last_name)
          expect(top_customers[3].last_name).to appear_before(top_customers[4].last_name)
        end
      end

      it "does not include failed transactions with my merchant" do
        not_top = create(:customer, :with_transactions, successful: 1, failed: 7, merchant: merchant)

        visit dashboard_merchant_path(merchant)

        expect(page).not_to have_content("#{not_top.first_name} #{not_top.last_name}")
      end

      it "does not include successful transactions with other merchants" do
        not_top = create(:customer, :with_transactions, successful: 7)

        visit dashboard_merchant_path(merchant)

        expect(page).not_to have_content("#{not_top.first_name} #{not_top.last_name}")
      end
    end

    describe 'items ready to ship' do
      before :each do
        @items = create_list(:item, 6, merchant: merchant)
        @items.first(4).each_with_index do |item, index|
          invoice = create(:invoice, merchant: merchant, id: item.id, created_at: (Date.today - index))
          create(:invoice_item, item: item, invoice: invoice, status: 1)
        end
      end

      it 'displays items that are ready to ship' do
        visit dashboard_merchant_path(merchant)

        expect(page).to have_content("Items Ready to Ship")
        within "#items_to_ship" do
          ready = @items.first(4).reverse
          not_ready = @items.last(2)
          ready.each_with_index do |item, index|
            within "#item-#{index}" do
              expect(page).to have_content(item.name)
              invoice = Invoice.find(item.id)
              expect(page).to have_link("Invoice ##{invoice.id}", href: merchant_invoice_path(merchant.id, invoice.id))
              expect(page).to have_content(invoice.created_at.strftime("%A, %B %-d, %Y"))
            end
          end
          not_ready.each do |item|
            expect(page).not_to have_content(item.name)
          end
        end
      end

      it 'displays items ordered by invoice creation date' do
        visit dashboard_merchant_path(merchant)

        invoices = Invoice.order(:created_at)
        expect("Invoice ##{invoices[0].id}").to appear_before("Invoice ##{invoices[1].id}")
        expect("Invoice ##{invoices[1].id}").to appear_before("Invoice ##{invoices[2].id}")
        expect("Invoice ##{invoices[2].id}").to appear_before("Invoice ##{invoices[3].id}")
      end
    end
  end
end
