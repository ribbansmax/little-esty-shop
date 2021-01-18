class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_many :bulk_discounts, through: :item

  enum status: ["pending", "packaged", "shipped"]

  delegate :name, to: :item, prefix: true

  def self.invoice_amount
    sum('quantity * unit_price')
  end

  def total_price
    # joins(:bulk_discounts).where('invoice_items.quantity >= bulk_discounts.threshold').sum('invoice_items.quantity * invoice_items.unit_price * (1 - bulk_discounts.discount)')
    # binding.pry
    potential_discounts = bulk_discounts.select do |discount|
      self.quantity >= discount.threshold
    end
    discount = potential_discounts.max_by do |discount|
      discount.discount
    end
    if discount
      quantity * unit_price * (1 - discount.discount)
    else
      quantity * unit_price
    end
  end

  def set_unit_price

    
    self.update('unit_price = ?', price)
  end
end
