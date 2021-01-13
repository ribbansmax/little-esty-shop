class Customer < ApplicationRecord
  has_many :invoices
  has_many :transactions, through: :invoices

  # def self.top_customers(number=5)
  #   unscope(:joins).select("customers.*, count(*)").top_by(:count, number)
  # end

  def self.top_customers(number = 5)
    unscope(:joins)
    .select("customers.*, count(*) AS count")
    .joins(:transactions)
    .where(transactions: {result: 0})
    .group(:id)
    .order("count DESC")
    .limit(number)
  end

  def number_of_successful_transactions
    transactions
    .where("result = ?", "0")
    .count
  end

  def name
    first_name + " " + last_name
  end

end
