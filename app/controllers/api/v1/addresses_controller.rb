class Api::V1::AddressesController < ApplicationController
  skip_before_action :verify_authenticity_token
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
    if !Address.exists?(params[:address_id])
      render json: { error: "Address not found" }, status: :unprocessable_entity
      return
    end

    address = Address.destroy(params[:address_id])

    render json: { error: "Address deleted successfully" }, status: :ok
  end

  def update 
    if !Address.exists?(id: params[:address_id])
      render json: { error: "Address not found" }, status: :unprocessable_entity
      return
    end

    address = Address.where(id: params[:address_id], user_id: @current_user[:id]).first
    if address.update(params_address)
      render json: { message: "Address updated successfully" }, status: :ok
      return
    end
    
    render json: { error: "Failed to updated address. Please check the provided data." }, status: :unprocessable_entity
  end

  def update_default 
    if !Address.exists?(id: params[:address_id])
      render json: { error: "Address not found" }, status: :unprocessable_entity
      return
    end

    Address.where(user_id: @current_user[:id]).update_all(is_default: false)
    address = Address.where(id: params[:address_id], user_id: @current_user[:id]).first
    if address.update(is_default: true)
      render json: { message: "Address set as default" }, status: :ok
      return
    end
    
    render json: { error: "Address cannot be set as default" }, status: :unprocessable_entity
  end

  def get
    page, data = pagy(Address.where(user_id: @current_user[:id]).order(is_default: :desc).all, page: params[:page], items: 5)
    pagination = pagy_metadata(page)

    render json: PaginationHelper.humanize_pagination(data, pagination), status: :ok
  end

  private
  def params_address
    params.require(:address).permit(:name, :country, :state, :district, :postal_code, :number, :complement, :phone_number, :street, :city)
  end
end
