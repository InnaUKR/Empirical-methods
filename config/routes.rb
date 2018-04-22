Rails.application.routes.draw do
  resources :data, only: :index do
    collection {post :'import'}
  end
  root 'data#index'
  match 'data/show_normal_regression' => 'data#show_normal_regression', :via => :get

end
