Rails.application.routes.draw do
  
  post '/game/start' => 'games#start'
  get '/game/status' => 'games#status'
  post '/game/play' => 'games#play'
  
end
