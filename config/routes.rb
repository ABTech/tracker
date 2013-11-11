Abtt::Application.routes.draw do
  resources :permissions
  resources :roles
  resources :locations
  resources :comments, only: [:create, :destroy]
  resources :members do
    collection do
      get 'edit_self'
    end
  end
  resources :accounts do
    collection do
      get 'list'
      get 'unpaid'
      get 'unpaid_print'
      get 'events'
      get 'confirm_paid'
    end
  end

  get 'calendar/generate.:format' => 'events#generate'
  get 'calendar' => 'events#calendar'
  get 'mobile' => 'events#mobile'
  get 'iphone' => 'events#iphone'
  get 'i' => 'events#iphone'
  post 'invoice/email/:id' => 'invoice#email'

  resources :organizations
  resources :bugs
  resources :tshirts
  get 'invoice/list' => 'invoice#list'
  resources :invoice
  resources :timecard_entries, except: :show
  resources :timecards do
    member do
      get 'view'
    end
  end
  resources :events do
    member do
      get 'delete_conf'
      get 'mobile_email'
    end
    collection do
      get 'calendar'
      get 'iphone'
      get 'mobile'
      get 'lost'
    end
  end

  resources :attachments, only: [:index, :destroy]

  resources :version, only: [:show]

  get 'login' => 'Useraccount#login'
  get 'logout' => 'Useraccount#logout'

  root to: 'events#index'

  resources :emailforms
#  get 'useraccount/access_denied' => 'Useraccount#access_denied'
end
