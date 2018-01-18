Rails.application.routes.draw do
  root to: 'welcome#index'
  get 'welcome/index'
  get 'uploaded_files/shell'
  get 'uploaded_files/clear_all_files'

  resources :uploaded_files

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
