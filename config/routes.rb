Rails.application.routes.draw do
  resources :doctors
  resources :comments
  resources :authors
  resources :doctors_specialties
  resources :groups
  resources :specialties
  put '/deactivate/:id', to: 'comments#update', defaults: { comment: { is_active: false } }, as: :deactivate_comment
  patch '/deactivate/:id', to: 'comments#update', defaults: { comment: { is_active: false } }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
