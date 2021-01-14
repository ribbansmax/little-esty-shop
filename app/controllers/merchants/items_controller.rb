class Merchants::ItemsController < ApplicationController
  before_action :get_item, only: [:show, :edit]

  def index
    @items = Merchant.find(params[:merchant_id]).items
  end

  def update
    get_item.update(item_params)
    if params[:item][:enabled]
      redirect_to merchant_items_path(params[:merchant_id])
    else
      flash.notice = ["Item has been updated!"]
      redirect_to item_path(@item)
    end
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.new
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.new(item_params.merge(enabled: false, merchant_id: params[:merchant_id]))
    if @item.save
      flash.notice = ["Successfully Added Item"]
      redirect_to merchant_items_path(params[:merchant_id])
    else
      flash.alert = @item.errors.full_messages
      render :new, obj: [@merchant, @item]
    end
  end

  private
  def get_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :enabled)
  end
end
