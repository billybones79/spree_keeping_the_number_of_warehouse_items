module Spree
  class ChaindriveController < Spree::Admin::BaseController
    def import
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
          SmarterCSV.process(file.path, {:col_sep =>';', :chunk_size => 100, :key_mapping => {:sku_skuid=>:sku, :sku_available =>:qty , :sku_eds => :eds}}) do |chunk|
            ChaindriveWorker.perform_async(chunk, log.id)


          end
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

    def revert
      session[:return_to] ||= request.referer
      begin
        RevertWorker.perform_async(params[:id])
      rescue Redis::CannotConnectError
        error = "Une erreur de connection est survenue"
      rescue StandardError
        error = "Une erreur inconnue est survenue"

      end
      if :return_to
        redirect_to session.delete(:return_to), :flash => error ? {:error =>error } : { :notice =>"operation lancée." }
      else
        redirect_to ("/admin"), :flash =>error ? {:error =>error } : { :notice =>"operation effectuée avec succés." }
      end
    end
    public
  end

  end


