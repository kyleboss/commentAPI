Rails.application.routes.draw do
  resources :doctors
  resources :comments
  resources :authors
  resources :doctors_specialties
  resources :groups
  resources :specialties
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
