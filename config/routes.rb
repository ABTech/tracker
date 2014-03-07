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

  resources :email, only: [:index, :view] do
    collection do
      get 'file'
      post 'file'
      get 'mark_status'
      get 'new_thread'
      post 'pull_email'
      get 'reply_to'
      get 'send_email'
      get 'unfile'
    end
    member do
      get 'view'
    end
  end

  resources :email_forms, except: [:show]

  resources :equipment, only: [] do
    collection do
      get 'delgroup'
      get 'delitem'
      get 'editgroup'
      get 'edititem'
      get 'newgroup'
      get 'newitem'
      post 'savegroup'
      post 'saveitem'
      get 'tree'
    end
  end

  resources :events do
    member do
      get 'delete_conf'
      get 'show_email'
      get 'finance'
    end
    collection do
      get 'calendar'
      get 'iphone'
      post 'iphone'
      get 'mobile'
      get 'months/:year/:month', to: :month, as: :month
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
  get 'mobile' => 'events#mobile'
  get 'iphone' => 'events#iphone'
  get 'i' => 'events#iphone'

  root to: 'events#index'
end
