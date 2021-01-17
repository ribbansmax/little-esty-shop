class Merchants::BulkDiscountsController < ApplicationController
  def index
    @discounts = Merchant.find(params[:merchant_id]).bulk_discounts
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.new
  end

  def create
    @bulk_discount = BulkDiscount.create(bulk_discount_params.merge(merchant_id: params[:merchant_id]))
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  def destroy
    @bulk_discount = BulkDiscount.find(params[:id])
    @bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  private

  def bulk_discount_params
    params.require(:bulk_discount).permit(:threshold, :discount)
  end
end