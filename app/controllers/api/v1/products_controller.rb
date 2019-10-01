class Api::V1::ProductsController < ApplicationController

  def regional_services
    service = Service.where(code: params[:service_code]).first
    if service.blank?
      render json: {message: "Service with code #{params[:service_code]} not found"}, status: :not_found and return
    end
    region = Region.where(code: /#{params[:region_code]}/i).first
    if region.blank?
      render json: {message: "Region with code #{params[:service_code]} not found"}, status: :not_found and return
    end
    qwery_params = {region_id: region.id, service_id: service.id}
    qwery_params[:effective_date] = /#{params[:date]}/i if params[:date].present?
    @products = Product.in(qwery_params)
  end
end
