Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations" }

  resources :posts do
    member do
      put "like",    to: "posts#upvote"
      put "dislike", to: "posts#downvote"
    end
    resources :comments
  end

  resources :comments do
    resources :comments
  end

  root "posts#index"
end
