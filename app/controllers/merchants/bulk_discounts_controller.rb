class Merchants::BulkDiscountsController < ApplicationController
  def index
    @discounts = Merchant.find(params[:merchant_id]).bulk_discounts
  end
end