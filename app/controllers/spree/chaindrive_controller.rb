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
              log = ImportLog.create(number: DateTime.now.to_s(:number))
              SmarterCSV.process(file.path, {:col_sep =>';', :chunk_size => 100, :key_mapping => {:sku_skuid=>:sku, :sku_available =>:qty , :sku_eds => :eds}}) do |chunk|
                ChaindriveController.delay.process_chunk chunk, log.id
              end
            rescue
              log.delete
              error = "Le fichier n'a pas le bon format"

            end
            if !error
              log.message = "operation effectuée avec succès."
              log.save
            end
          end

        if(:return_to)
          redirect_to session.delete(:return_to), :flash => error ? {:error =>error } : { :notice =>"operation en cours." }
        else
          redirect_to ("/admin"), :flash =>error ? {:error =>error } : { :notice =>"operation en cours." }
        end
      end
      public
        def self.process_chunk chunk, log_id
          log = ImportLog.find(log_id)
          begin
          chunk.each do |row|
            variant = Spree::Variant.where(sku: row[:sku]).first
            if variant && row[:qty].is_a?(Integer)
              location = Spree::StockLocation.where(:default => true).first()
              if location
                location.import_warehouse_item(variant, row[:qty], log)
              else
                log.message =  "Il n'y a pas de location par défaut, veuillez en sélectionner une."
                log.save
                break
              end
            end
          end
          rescue
            if log.message ==  "operation effectuée avec succès."
              log.message = "Il y a eu une erreur lors du traitement de la tâche, il se pourrait que certains élements ne se soit pas ajusté correctement."
              log.save
            end
          end
        end
    end
  end


