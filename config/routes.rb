Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }

  get '/:id', to: 'messages#show', as: 'message'
  post '/:id', to: 'messages#create', as: 'messages'
  root to: 'messages#index'
end
