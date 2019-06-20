Rails.application.routes.draw do
  scope "solr-api", module: :solr_api do
    namespace :v1 do
      get :select, to: :select
    end
  end
end
