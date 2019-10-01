Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/service/:service_code/region/:region_code', to: 'api/v1/products#regional_services'
end