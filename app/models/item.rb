class Item < ApplicationRecord
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :customers, through: :invoices
  has_many :bulk_discounts, through: :merchant
  belongs_to :merchant

  validates_presence_of :name, :description, :unit_price

  scope :enabled, -> {where(enabled: true)}
  scope :disabled, -> {where(enabled: false)}

  delegate :top_sales_day, to: :invoices

  def self.items_to_ship
    joins(:invoices)
    .select("items.*, invoice_id, invoices.created_at AS invoice_created")
    .where(invoice_items: {status: 1})
    .order("invoice_created")
  end

  def self.popular_items
    select("items.*, sum(invoice_items.unit_price * invoice_items.quantity) as total_revenue")
    .joins(invoices: :transactions)
    .where("transactions.result = 0")
    .group(:id).order(total_revenue: :desc)
    .limit(5)
  end
end
