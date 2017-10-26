Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :jsons
  get '/msg' => 'send_messages#send_message'
  get '/gmsg' => 'send_messages#send_group_message'


end
