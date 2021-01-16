class Customer < ApplicationRecord
  has_many :invoices
  has_many :transactions, through: :invoices

  delegate :number_of_successful_transactions, to: :transactions

  def self.top_customers(number = 5)
    select("customers.*, count(*) AS count")
    .joins(:transactions)
    .where(transactions: {result: 0})
    .group(:id)
    .order("count DESC")
    .limit(number)
  end
end
