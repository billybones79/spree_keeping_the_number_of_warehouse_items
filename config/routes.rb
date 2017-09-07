Spree::Core::Engine.routes.draw do
  # Add your extension routes here
    namespace :admin do
        post '/chaindrive/import', to: "chaindrive#import", as: :chaindrive_import
        get '/chaindrive/revert/:id', to: "chaindrive#revert", as: :chaindrive_revert
        get '/import_logs', to: "import_log#index", as: :import_logs
        get '/import_log/:id', to: "import_log#show", as: :import_log

    end


end
