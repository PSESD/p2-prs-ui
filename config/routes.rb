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
    resources :services, controller: "districts/services" do
      resources :students, controller: "districts/students" do
        member do
          get 'filters'
        end
      end
    end
  end
  
  # Root URL
  root "districts#index"
end
