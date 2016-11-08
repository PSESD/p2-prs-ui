Rails.application.routes.draw do

  # Authorized Entities
  resources :authorized_entities do
    resources :services, controller: "authorized_entities/services"
  end

  # Data Sets
  resources :data_sets do
    resources :data_objects, controller: "data_sets/data_objects"
  end

  # Districts
  resources :districts do
    member do
      get 'consent_form'
    end

    # post '/api/machines' do
      # header "Content-Type", "application/json"

      # let(:raw_post) { params.to_json }
    # end


    resources :services, controller: "districts/services" do
      resources :students, controller: "districts/students" do
        collection do
          get 'bulk_create/:id', action: 'bulk_create', as: 'bulk_create_status'
        end
        member do
          get 'filters'
        end
      end
    end
  end

  # Student Success Link
  namespace :student_success_link do
    get '/', controller: "organizations", action: 'index'
    resources :organizations do
      member do
        post 'add_admin_user'
      end
    end
    resources :users
  end

  # Root URL
  root "districts#index"
end
