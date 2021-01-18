class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  belongs_to :bulk_discount, optional: true
  after_create :find_discount, :calculate_unit_price

  enum status: ["pending", "packaged", "shipped"]

  delegate :name, to: :item, prefix: true

  def self.invoice_amount
    sum('quantity * unit_price')
  end

  def find_discount
    my_discount = BulkDiscount.where(merchant_id: self.item.merchant_id).where('bulk_discounts.threshold <= ?', self.quantity).order(discount: :desc).pluck(:id).first
    self.update(bulk_discount_id: my_discount)
  end

  def calculate_unit_price
    self.update(unit_price: (self.item.unit_price.to_f * (1 - applied_discount)).round(2))
  end

  def applied_discount
    if bulk_discount
      bulk_discount.discount
    else
      0
    end
  end
end
