class Transaction < ApplicationRecord
  belongs_to :invoice

  enum result: ["success", "failed"]

  def self.number_of_successful_transactions
    where("result = ?", "0")
    .count
  end
end
