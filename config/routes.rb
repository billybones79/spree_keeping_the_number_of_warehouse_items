Spree::Core::Engine.routes.draw do
  # Add your extension routes here
    post '/chaindrive/import', to: "chaindrive#import", as: :chaindrive_import

    namespace :admin do
    get '/import_logs', to: "import_log#index", as: :import_logs
    get '/import_log/:id', to: "import_log#show", as: :import_log

    end


end
