require "rails_helper"

describe InvoiceItem, type: :model do
  describe "validations" do
    it {should define_enum_for(:status).with_values ["pending", "packaged", "shipped"] }
  end

  describe "relations" do
    it {should belong_to :invoice}
    it {should belong_to :item}
  end

  describe "delegates" do
    it "fine" do
      create(:invoice_item)
      expect(InvoiceItem.first.item.name).to eq(InvoiceItem.first.item_name)
    end
  end
end
