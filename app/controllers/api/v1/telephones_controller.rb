class Api::V1::TelephonesController < ApplicationController
  before_action :authorize_request

  def create
    if Telephone.exists?(postal_code: params_telephone[:postal_code])
      render json: { error: "Telephone already exists" }, status: :unprocessable_entity
      return
    end

    @telephone = Telephone.new(user_id: @current_user[:id], **params_telephone)
    if @telephone.save
      render json: { message: "Telephone created successfully" }, status: :ok
      return
    end

    render json: { error: "Failed to create telephone. Please check the provided data." }, status: :unprocessable_entity
  end

  def delete
    if !Telephone.exists?(params[:id])
      render json: { error: "Telephone not found" }, status: :unprocessable_entity
      return
    end

    @telephone = Telephone.destroy(params[:id])

    render json: { error: "Telephone deleted successfully" }, status: :ok
  end

  def get
    page, data = pagy(Telephone.where(user_id: @current_user[:id]).all, page: params[:page])
    pagination = pagy_metadata(page)

    render json: PaginationHelper.humanize_pagination(data, pagination), status: :ok
  end

  private
  def params_telephone
    params.require(:telephone).permit(:name, :area_code, :phone_number)
  end
end
