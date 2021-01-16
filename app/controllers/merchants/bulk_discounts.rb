class Merchants::BulkDiscountsController < ApplicationController
  def index
    @discounts = Merchant.find(params[:merchant_id]).discounts
  end
end