require "rails_helper"

describe InvoiceItem, type: :model do
  describe "validations" do
    it {should define_enum_for(:status).with_values ["pending", "packaged", "shipped"] }
  end

  describe "relations" do
    it {should belong_to :invoice}
    it {should belong_to :item}
  end

  describe "class methods" do 
    it "invoice_amount" do 
      invoice = FactoryBot.create(:invoice)
      ii1 = FactoryBot.create(:invoice_item, invoice_id:invoice.id, quantity: 3, unit_price: 5) #15
      ii2 = FactoryBot.create(:invoice_item, invoice_id:invoice.id, quantity: 4, unit_price: 5) #20 
      ii3 = FactoryBot.create(:invoice_item, invoice_id:invoice.id, quantity: 5, unit_price: 5) #25

      expect(invoice.invoice_items.invoice_amount).to eq(15+20+25)
    end
  end

  describe "instance methods" do
    it "can calculate invoice_amount factoring in discounts" do
      merchant = FactoryBot.create(:merchant)
      item = FactoryBot.create(:item, merchant: merchant)
      invoice = FactoryBot.create(:invoice)
      invoice2 = FactoryBot.create(:invoice)
      bulk_discount = FactoryBot.create(:bulk_discount, merchant: merchant, threshold: 4)
      bulk_discount2 = FactoryBot.create(:bulk_discount, merchant: merchant, threshold: 100, discount: 0.99)
      invoice_item1 = FactoryBot.create(:invoice_item, invoice: invoice, item: item, quantity: 4)
      invoice_item2 = FactoryBot.create(:invoice_item, invoice: invoice2, item: item, quantity: 3)
      invoice_item3 = FactoryBot.create(:invoice_item, invoice: invoice, item: item, quantity: 10)
      invoice_item4 = FactoryBot.create(:invoice_item, invoice: invoice, item: item, quantity: 110)

      expect(invoice_item1.total_price).to eq(invoice_item1.quantity * invoice_item1.unit_price * (1 - bulk_discount.discount))
      expect(invoice_item2.total_price).to eq(invoice_item2.quantity * invoice_item2.unit_price)
      expect(invoice_item3.total_price).to eq(invoice_item3.quantity * invoice_item3.unit_price * (1 - bulk_discount.discount))
      expect(invoice_item4.total_price).to eq(invoice_item4.quantity * invoice_item4.unit_price * (1 - bulk_discount2.discount))
    end
  end

  describe "delegates" do
    it "fine" do
      create(:invoice_item)
      expect(InvoiceItem.first.item.name).to eq(InvoiceItem.first.item_name)
    end
  end
end
