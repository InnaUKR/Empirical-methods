Rails.application.routes.draw do
  resources :data, only: :index do
    collection {post :import}
  end

end
