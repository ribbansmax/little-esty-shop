require "rails_helper"

describe Merchant, type: :model do
  let(:merchant) {create(:merchant)}

  describe "relations" do
    it {should have_many :invoices}
    it {should have_many :items}
    it {should have_many :bulk_discounts}
    it {should have_many(:customers).through(:invoices)}
  end

  describe "validations" do
    it {should validate_presence_of :name}
  end

  describe "delegates" do
    it "top_customers;" do
      top_customers = [
          create(:customer, :with_transactions, successful: 6, merchant: merchant),
          create(:customer, :with_transactions, successful: 5, merchant: merchant),
          create(:customer, :with_transactions, successful: 4, merchant: merchant),
          create(:customer, :with_transactions, successful: 3, merchant: merchant),
          create(:customer, :with_transactions, successful: 2, merchant: merchant),
        ]
      not_top =  [
        create(:customer, :with_transactions, successful: 1, merchant: merchant),
        create(:customer, :with_transactions, successful: 1, failed: 7, merchant: merchant),
        create(:customer, :with_transactions, successful: 7)
      ]

      expect(merchant.top_customers).to eq(top_customers)
    end

    it 'items_to_ship;' do
      ready_to_ship = create_list(:item, 4, :with_status, status: "packaged", merchant: merchant)
      not_ready = [
        create(:item, :with_status, status: "pending", merchant: merchant),
        create(:item, :with_status, status: "shipped", merchant: merchant),
        create(:item, merchant: merchant),
        create(:item, :with_status, status: "packaged")
      ]

      expect(merchant.items_to_ship).to eq(ready_to_ship)
    end

    it "top_sales_day" do
      create(:item, :sold, merchant: merchant, unit_price: 100, invoice_date: Date.today)
      create(:item, :sold, merchant: merchant, unit_price: 150, invoice_date: Date.today + 1.day)
      create(:item, :sold, merchant: merchant, unit_price: 200, invoice_date: Date.today + 2.days)

      expect(merchant.top_sales_day).to eq(Date.today + 2.days)
    end

    it "total_revenue" do
      create_list(:item, 10, :sold, merchant: merchant, sales: 10)

      expect(merchant.total_revenue).to eq(100)
    end
  end

  describe "class methods" do
    it "top_merchants" do
      merchant1 = create(:merchant)
      create(:item, :sold, merchant: merchant1, sales: 1)
      merchant2 = create(:merchant)
      create(:item, :sold, merchant: merchant2, sales: 2)
      merchant3 = create(:merchant)
      create(:item, :sold, merchant: merchant3, sales: 3)

      expect(Merchant.top_merchants(1)).to eq([merchant3])
      expect(Merchant.top_merchants(2)).to eq([merchant3, merchant2])
    end
  end
end
