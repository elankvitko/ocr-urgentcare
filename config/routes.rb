Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => "home#index"
  post '/upload-ocr' => "home#ocr_checker"
  get '/instructions' => "instructions#index"
end
