class Merchants::BulkDiscountsController < ApplicationController
  def index
    @discounts = Merchant.find(params[:merchant_id]).bulk_discounts
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.new
  end

  def create
    @bulk_discount = BulkDiscount.new(bulk_discount_params.merge(merchant_id: params[:merchant_id]))
    if @bulk_discount.save
      flash.notice = ["Successfully Added Discount"]
      redirect_to merchant_bulk_discounts_path(params[:merchant_id])
    else
      flash.alert = @bulk_discount.errors.full_messages
      redirect_to new_merchant_bulk_discount_path(params[:merchant_id])
    end
  end

  def destroy
    @bulk_discount = BulkDiscount.find(params[:id])
    @bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    @bulk_discount = BulkDiscount.find(params[:id])
    @bulk_discount.update(bulk_discount_params)
    flash.notice = ["Discount has been updated!"]
    redirect_to merchant_bulk_discount_path(params[:merchant_id], @bulk_discount)
  end

  private

  def bulk_discount_params
    params.require(:bulk_discount).permit(:threshold, :discount)
  end
end