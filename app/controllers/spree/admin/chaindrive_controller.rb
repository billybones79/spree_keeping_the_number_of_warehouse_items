module Spree
  module Admin
    class ChaindriveController < Spree::Admin::BaseController
      def form
      end

      def import
        if params[:time]
          at = Time.strptime(params[:time], "%d/%m/%Y %H:%M")
        else
          at = Time.now + 2.minutes
        end

        session[:return_to] ||= request.referer
        file = params[:chaindrive_file].tempfile
        if File.extname(file.path) != ".csv"
          error = "mauvais type de fichier : "+File.extname(file.path)
        end
        #Dir.glob("*").max_by{|f| /^(.+?)_/.match(File.basename(f)).captures[0]}
        if !error

          begin
            log = ImportLog.create(number: DateTime.now.to_s(:number), filename: params[:chaindrive_file].original_filename)
            log.message = "operation effectuée avec succés."
            log.save
            data = SmarterCSV.process(file.path, {:col_sep =>';', :key_mapping => {:sku_skuid=>:sku, :sku_available =>:qty , :sku_eds => :eds}})
            ChaindriveWorker.perform_at(at, data, log.id)


          rescue Redis::CannotConnectError
            log.delete
            error = "Une erreur de connection est survenue"
          rescue StandardError
            error = "Une erreur inconnue est survenue"

          end
        end

        if(:return_to)
          redirect_to session.delete(:return_to), :flash => error ? {:error =>error } : { :notice =>"operation effectuée avec succés." }
        else
          redirect_to ("/admin"), :flash =>error ? {:error =>error } : { :notice =>"operation effectuée avec succés." }
        end
      end

    end
  end

end
