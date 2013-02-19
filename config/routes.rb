Gandhi::Application.routes.draw do
  root :to => 'gandhi#index'
  get "gandhi/index"
  get "gandhi/new"
  post "api/create_message"
  get "api/view_message"
end
