BackApp::Application.routes.draw do

  match 'posts/search' => 'posts#search'
  match '/signup', :to => 'users#new'
  match '/signin', :to => 'sessions#new'


  get 'posts/reply'
  get 'votes/handle'
  get 'users/showStats'
  get 'votes/showStats'
  get 'users/destroy'
  get 'votes/showHome'
  get 'sessions/destroy'
  post 'posts/addReply'
  post 'posts/search'




  resources :posts
  resources :users
  resources :sessions
  resource :votes

  root :to=> 'posts#index'
  root :controller => 'posts', :action => 'reply'

end
