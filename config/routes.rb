Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'board#index'
  get '/board/report', to: 'board#report'
  patch '/board/move', to: 'board#move'
  patch '/board/change_direction', to: 'board#change_direction'
  post '/board/place', to: 'board#place'
  delete '/board', to: 'board#end'

  get '/board', to: 'board#index'
end
