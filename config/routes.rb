Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :jsons
  get '/msg' => 'send_messages#send_message'



end
