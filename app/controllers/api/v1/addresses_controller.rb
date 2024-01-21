class Api::V1::AddressesController < ApplicationController
  before_action :authorize_request

  def create
    if Address.exists?(postal_code: params_address[:postal_code])
      render json: { error: "Address already exists" }, status: :unprocessable_entity
      return
    end

    address = Address.new(user_id: @current_user[:id], **params_address)
    if address.save
      render json: { message: "Address created successfully" }, status: :ok
      return
    end

    render json: { error: "Failed to create address. Please check the provided data." }, status: :unprocessable_entity
  end

  def delete
    if !Address.exists?(params[:id])
      render json: { error: "Address not found" }, status: :unprocessable_entity
      return
    end

    address = Address.destroy(params[:id])

    render json: { error: "Address deleted successfully" }, status: :ok
  end

  def get
    page, data = pagy(Address.where(user_id: @current_user[:id]).all, page: params[:page])
    pagination = pagy_metadata(page)

    render json: PaginationHelper.humanize_pagination(data, pagination), status: :ok
  end

  private
  def params_address
    params.require(:address).permit(:name, :country, :state, :district, :postal_code, :number, :complement)
  end
end
