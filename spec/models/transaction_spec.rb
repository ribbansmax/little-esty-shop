require "rails_helper"

describe Transaction, type: :model do
  describe "validations" do
    it {should define_enum_for(:result).with_values ["success", "failed"] }
  end

  describe "relations" do
    it {should belong_to :invoice}
  end

  describe "class methods" do
    it "number_of_successful_transactions" do
      create_list(:transaction, 5, result: 0)

      expect(Transaction.number_of_successful_transactions).to eq(5)
    end
  end
end
