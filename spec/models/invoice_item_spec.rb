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
      item = FactoryBot.create(:item, unit_price: 5)
      ii1 = FactoryBot.create(:invoice_item, invoice_id:invoice.id, quantity: 3, item: item) #15
      ii2 = FactoryBot.create(:invoice_item, invoice_id:invoice.id, quantity: 4, item: item) #20 
      ii3 = FactoryBot.create(:invoice_item, invoice_id:invoice.id, quantity: 5, item: item) #25

      expect(invoice.invoice_items.invoice_amount).to eq(15+20+25)
    end
  end

  describe "instance methods" do
    it "can calculate unit_price factoring in discounts" do
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

      expect(invoice_item1.unit_price).to eq((item.unit_price.to_f * (1 - bulk_discount.discount)).round(2))
      expect(invoice_item2.unit_price).to eq(item.unit_price)
      expect(invoice_item3.unit_price).to eq((item.unit_price.to_f * (1 - bulk_discount.discount)).round(2))
      expect(invoice_item4.unit_price).to eq((item.unit_price.to_f * (1 - bulk_discount2.discount)).round(2))
    end
  end

  describe "delegates" do
    it "fine" do
      create(:invoice_item)
      expect(InvoiceItem.first.item.name).to eq(InvoiceItem.first.item_name)
    end
  end
end
