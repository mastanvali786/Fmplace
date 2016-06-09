Rails.application.routes.draw do

  match '/payments/payment', :to => 'payments#payment', :as => 'paymentspayment', :via => [:get]
  match '/payments/thank_you', :to => 'payments#thank_you', :as => 'payments_thank_you', :via => [:get]
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users ,:controllers => { sessions: 'sessions', :registrations => "registrations", passwords: 'passwords',:omniauth_callbacks => "omniauth_callbacks" }
  devise_scope :user do
    get "users/signup_seller" => "devise/registrations#new"
    get "users/signup_buyer" => "devise/registrations#new"
    get "registrations/login_as_admin" =>"registrations#login_as_admin"
 end

  match 'payments/:id' => "payments#show", via:[:get], as: :payment
  get "admin/payments"
  get "admin/withdrawal_requests"
  match "admin/payments/:id/approve" => "admin#approve_payment", via: [:put], as: :approve_payment
  get "milestones/invoice/:id" => "milestone_invoices#show", as: "milestone_invoice"
  get "milestones/invoices" => "milestone_invoices#index"
  get "milestones/invoice/funded/:id" => "milestone_invoices#funded", as:"milestone_invoice_funded"
  resources :invoices

  # Routes for Dashboard Popup
  get 'admin/projects/view_project/:id' => "admin/projects#view_project"
  get 'admin/payments/payfast_withdrawals/:id' => "admin/payments#payfast_withdrawals"
  get 'admin/payments/authorize_credit_withdrawals/:id' => "admin/payments#authorize_credit_withdrawals"


  #routes for lock & unlock sites
  get '/webservice/lock_website'
  get '/webservice/unlock_website'
  post '/webservice/lock_website'
  post '/webservice/unlock_website'


  # Membership
  resources :memberships do
    collection do
      get "current_status"
    end
  end
  post '/memberships/upgrade_plan'

  # Team
  resources :teams
  match "/teams/:id" => "teams#update", via: [:put], as: "team_update"
  resources :users

  #resources :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'homes#index'

  post 'ipn/paypal', as: :ipn_paypal
  post 'ipn/payfast', as: :ipn_payfast
  post 'ipn/payfast_withdraw', as: :ipn_payfast_withdraw
  post 'ipn/payfast_deposit', as: :ipn_payfast_deposit
  post 'ipn/authorize_credit', as: :ipn_authorize_credit
  post 'ipn/authorize_credit_deposit', as: :ipn_authorize_credit_deposit
 
  get 'homes/blog'
  get 'homes/news'
  get 'homes/faq'
  get 'homes/freelancers'
  get 'homes/about_us'
  get 'homes/how_it_works'
  get 'homes/privacy'
  get 'homes/terms'
  get 'homes/login_admin_user'
  get 'homes/demo_logins'
  post 'homes/demo_logins'
  get 'homes/auction'
  get 'homes/freelancer_confirmation'
  get 'homes/user_confirmation'
  
  get '/themes/set_theme'
  post '/themes/set_theme'

   get 'homes/learning_faq'
   get 'homes/engine_lookup'
   match "inbox/inbox" => "inbox#inbox", as: :inbox, via: [:get, :post]
   match "inbox/new_message" => "inbox#new_message", as: :new_message, via: [:get, :post]
   match "homes/engines" => "homes#engines", as: :engines, via: [:get, :post]  
   match "homes/contact" => "homes#contact", as: :contact, via: [:get, :post]  

  match "projects/sign_out_redirect_registration" => "projects#sign_out_redirect_registration", as: :sign_out_register, via: [:get, :post]
  match "projects/sshops" => "projects#sshops", as: :sshops, via: [:get, :post]  
  match "projects/change_status" => "projects#change_status", as: :change_status, via: [:get, :post]  
  match "projects/destroy_attachment" => "projects#destroy_attachment", as: :destroy_attachment, via: [:get, :post]
  match "projects/project_attachment" => "projects#project_attachment", as: :project_attachment, via: [:get, :post]
  post '/projects/post_public_message/:id' => 'projects#post_public_message'
  post '/projects/post_public_message' => 'projects#post_public_message'
  post '/projects/update_subcategoires'
  post '/projects/update_project_budget'
  post '/projects/update_states'
  post '/projects/listzip'
  match ':controller/:action/.:format', via: [:get, :post]
  match "projects/find_freelancers" => "projects#find_shops", as: :find_shops, via: [:get, :post]
  match "account/listcat" => "account#listcat", as: :listcat, via: [:get, :post]
  match "projects/find_projects" => "projects#find_projects", as: :find_projects, via: [:get, :post]
  match "account/user_info_edit" => "account#user_info_edit", as: :user_info_edit, via: [:get, :post]
  match "account/user_public_profile" => "account#user_public_profile", as: :user_public_profile, via: [:get, :post]
  match "account/my_preferences" => "account#my_preferences", as: :my_preferences, via: [:get, :post,:put,:patch]
  # match "account/team" => "account#team", as: :team, via: [:get, :post,:put,:patch]
  match "account/public_profile" => "account#public_profile", as: :public_profile, via: [:get, :post]
  match "account/user_image_edit" => "account#user_image_edit", as: :user_image_edit, via: [:get, :post]
  match "account/user_info" => "account#user_info", as: :user_info, via: [:get, :post]
  match "account/public_profile_edit" => "account#public_profile_edit", as: :public_profile_edit, via: [:get, :post,:put,:patch]
  match "bids/hide_unhide_bid" => "bids#hide_unhide_bid", as: :hide_unhide_bid, via: [:get, :post,:put,:patch]
  match "bids/decline_bid" => "bids#decline_bid", as: :decline_bid, via: [:get, :post,:put,:patch]
  match "bids/change_bid_status" => "bids#change_bid_status", as: :change_bid_status, via: [:get, :post]

  get "projects/action/message"
  get "projects/action/file"
  get "projects/action/proposal"
  get "projects/action/payment"
  get "projects/action/mark"
  get "projects/action/milestone"
  get "projects/action/feedback"
  get "projects/action/dispute"
  post "projects/action/upload"
  post "projects/action/complete_project"
  get "projects/action/milestone_pdf"
  
  resources :projects

  resources :guest_user

  resources :bids, :except => :destroy do
    member do
      put 'withdraw'
    end
  end

  get 'milestones/popup/new' => 'milestones#popup_new'

 resources :milestones do
  member do
    get 'popup'
    put 'accepted'
    put 'rejected'
    put 'request/fund', action:"request_fund"
    put 'release/fund', action:"release_fund"
    put 'fund', action:"fund"
    put 'payfast_fund', action:"payfast_fund"
    put 'pay_fast_request_fund'
  end
end

match "referal_program/referral_program" => "referal_program#referral_program", as: :referral_program, via: [:get, :post,:put,:patch]
match "referal_program/referral_account" => "referal_program#referral_account", as: :referral_account, via: [:get, :post,:put,:patch]

get 'admin/withdrawal/requests' => 'admin#withdrawal_requests'
get 'withdrawal/requests' => 'withdrawals#requests'
get 'withdrawal/request/:id' => 'withdrawals#show', as: :withdrawal_request

get 'deposits/requests' => 'deposits#requests'
get 'deposits/request/:id' => 'deposits#show', as: :deposit_request
get "deposit/invoice/:id" => "deposit_invoices#show", as: "deposit_invoice"
get "deposit/invoices" => "deposit_invoices#index"

resources :messages, only: [:index, :create, :show] do
  collection do
    put 'delete'
    put 'save'
    post 'mutiple_messages', action: :mutiple_messages
    post 'do_coversation', action: :do_coversation
    get 'popup/new', action: :popup_new
  end
end

resources :project_messages, only: [:new, :create] do
  collection do
    put 'delete'
    put 'save'
  end
end

resources :bid_attachments, only: [:destroy]
resources :bid_milestones, only: [:destroy]
 post 'disputes' => 'dispute#create'
 post 'bids/update_my_notes'
 post 'messages/send_praposal_message'
 post 'bids/send_report_violation'
resources :feedback

#payment actions
  get '/accounting/make_payment'
  get '/accounting/payment_list'
  get '/accounting/account_list'
  get '/accounting/transactions'
  get '/accounting/withdrawals'
  get '/accounting/deposits'
  put 'accounting/withdraw'
  get "accounting/transaction_pdf"
  get "accounting/payment_list_pdf"
  post "accounting/save_account"
  patch "accounting/save_account"
  post "accounting/deposit"
  patch "accounting/deposit"
  post "accounting/save_account_settings"
  post "accounting/bank_details"
  get '/accounting/undefined' => 'accounting#deposits'

  #earnings actions
  get '/earnings/send_invoice'
  post '/guest_user/record_feedback'
  get 'homes/sign_up', as: "hire_work"

  match "account/user_biography" => "account#user_biography", as: :biography, via: [:get, :post,:put,:patch]
  match "account/domain_expertise" => "account#domain_expertise", as: :domain_expertise, via: [:get, :post,:put,:patch]
  match "account/user_skills" => "account#user_skills", as: :user_skills, via: [:get, :post,:put,:patch]
  match "account/user_experience" => "account#user_experience", as: :user_experience, via: [:get, :post,:put,:patch]
  match "account/user_experience_edit" => "account#user_experience_edit", as: :user_experience_edit, via: [:get, :post,:put,:patch]
  match "account/user_education" => "account#user_education", as: :user_education, via: [:get, :post,:put,:patch]
  match "account/user_education_edit" => "account#user_education_edit", as: :user_education_edit, via: [:get, :post,:put,:patch]

  resources :transactions, only: [:edit, :create]

  #Moble API
  get 'api/time_zones' => 'api#time_zones'
   get 'api/get_my_preferences' => 'api#get_my_preferences'
  get 'api/get_token' => 'api#get_token'
  match "api/dashboard_info" => "api#dashboard_info", as: :api_dashboard_info, via: [:get, :post,:put,:patch]
  post 'api/get_categories' => 'api#get_categories'

  post 'api/get_countries' => 'api#get_countries'

  post 'api/get_project_tags' => 'api#get_project_tags'

  post 'api/get_skills' => 'api#get_skills'

  post 'api/get_project_budgets' => 'api#get_project_budgets'
  
  post 'api/get_project_framework' => 'api#get_project_framework'

  post 'api/get_budgets_types' => 'api#get_budgets_types'

  # Advertisement
  
  match 'advertisements/make_active_inactive' => 'advertisements#make_active_inactive', :via => [:get, :post]
  match 'advertisements/remove_banner' => 'advertisements#remove_banner', :via => [:get, :post, :delete]
  match 'advertisements/click_on_ads' => 'advertisements#click_on_ads', :via => [:get, :post]
  resources :advertisements do
    collection do
      get 'advertisements/all_advertisements'
    end
  end

  get 'admin/freelancer_report' => 'admin/reports#freelancer_report'
  post 'admin/freelancer_report_excel' => 'admin/reports#freelancer_report_excel'

end
