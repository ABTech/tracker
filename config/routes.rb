Abtt::Application.routes.draw do
  resources :accounts do
    collection do
      post 'confirm_paid'
      get 'events'
      get 'list'
      get 'unpaid'
      get 'unpaid_print'
    end
  end

  resources :attachments, only: [:destroy, :index]
  
  resources :blackouts, except: [:show]

  resources :comments, only: [:create, :destroy]

  resources :emails, only: [:index, :show, :update] do
    collection do
      get 'sent'
      get 'unread'
      get 'reply'
      post 'reply', action: "send_reply"
      get 'new_event'
      get 'existing_event'
      get 'weekly'
      post 'weekly', action: "send_weekly"
    end
  end

  resources :email_forms, except: [:show]

  resources :equipment

  resources :events do
    member do
      get 'delete_conf'
      get 'finance'
      get 'duplicate'
    end
    collection do
      get 'calendar'
      get 'iphone'
      post 'iphone'
      get 'mobile'
      get 'months/:year/:month', action: :month, as: :month
      get 'past'
      get 'incomplete'
      get 'search'
    end
  end

  resources :invoices do
    member do
      post 'email'
      get 'email_confirm'
      get 'prettyView'
    end
  end  

  resources :invoice_items, except: [:show]

  resources :journals, except: [:show, :update] do
    collection do
      get 'list'
      post 'save'
    end
    member do
      get 'view'
    end
  end

  resources :locations

  resources :member_filter, only: [:edit, :new, :save]

  devise_for :members
  resources :members do
    collection do
      get 'tshirts'
      get 'roles'
      get 'choose_filter'
      get 'super_tics'
      post 'super_tics', action: :update_super_tics
      get 'bulk_edit'
      post 'bulk_edit', action: :bulk_update
    end
  end

  resources :organizations

  resources :timecards do
    member do
      get 'view'
    end
  end

  resources :timecard_entries, except: :show

  post 'login' => 'useraccount#login'
  get 'logout' => 'useraccount#logout'
  get 'useraccount/access_denied'

  get 'calendar/generate.:format' => 'events#generate'
  get 'calendar' => 'events#calendar'
  get 'calendar/callfeed' => 'events#callfeed'
  get 'mobile' => 'events#mobile'
  get 'iphone' => 'events#iphone'
  get 'i' => 'events#iphone'

  root to: 'events#index'
end
