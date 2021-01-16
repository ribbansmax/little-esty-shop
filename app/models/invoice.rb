class Invoice < ApplicationRecord
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  has_many :merchants, through: %i[invoice_items items]
  belongs_to :customer

  enum status: ['in progress', 'completed', 'cancelled']

  delegate :invoice_amount, to: :invoice_items

  def self.incomplete_invoices
    where(status: "in progress").order(created_at: :asc)
  end

  def self.top_sales_day
    joins(:transactions)
    .where(transactions: {result: 0})
    .select("CAST (invoices.created_at AS DATE), sum(quantity * invoice_items.unit_price) as revenue")
    .group(:created_at)
    .order("revenue"=> :desc, :created_at=> :desc)
    .first.created_at
  end

  def self.total_revenue
    joins(:transactions)
    .where(transactions: {result: 0})
    .sum("quantity * invoice_items.unit_price")
  end
end
