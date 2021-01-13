class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :customers,-> {distinct}, through: :invoices

  validates :name, presence: true

  delegate :favorite_customers, to: :customers
  delegate :items_to_ship, to: :items
  delegate :total_revenue, to: :invoices
  delegate :best_day, to: :invoices

  def self.top_merchants(number = 5)
    joins(invoices: [:transactions, :invoice_items])
    .where("result = 0")
    .group(:id)
    .select('merchants.*, sum(quantity * unit_price) as total_revenue')
    .order("total_revenue" => :desc)
    .limit(number)
  end
end
