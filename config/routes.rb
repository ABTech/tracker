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

  resources :email_forms

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
      get 'treesave'
      get 'usage'
    end
  end

  resources :events do
    member do
      get 'delete_conf'
      get 'mobile_email'
      get 'show_email'
      get 'finance'
    end
    collection do
      get 'delete_conf'
      get 'calendar'
      get 'iphone'
      post 'iphone'
      get 'mobile'
      get 'lost'
    end
  end

  resources :heartbeat, only: [:index]

  resources :invoices, :except => [:destroy] do
    collection do
      get 'email'
      get 'email_confirm'
      get 'prettyView'
    end
  end  

  resources :invoice_items, except: [:show]

  resources :journal, except: [:show, :update] do
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

  resources :members do
    collection do
      get 'edit_self'
    end
  end

  resources :organizations

  resources :permissions

  resources :roles

  resources :timecards do
    member do
      get 'view'
    end
  end

  resources :timecard_entries, except: :show

  resources :tshirts, only: :index

  resources :version, only: :show

  post 'login' => 'useraccount#login'
  get 'logout' => 'useraccount#logout'
  get 'useraccount/access_denied'

  get 'calendar/generate.:format' => 'events#generate'
  get 'calendar' => 'events#calendar'
  get 'mobile' => 'events#mobile'
  get 'iphone' => 'events#iphone'
  get 'i' => 'events#iphone'
  post 'invoices/email/:id' => 'invoices#email'

  root to: 'events#index'
end
