module Spree
    class ChaindriveController < Spree::Admin::BaseController
      def import


          session[:return_to] ||= request.referer
          file = params[:chaindrive_file].tempfile
          puts "ca start, mais fuck"
          if File.extname(file.path) != ".csv"
            error = "mauvais type de fichier : "+File.extname(file.path)
          end

          #Dir.glob("*").max_by{|f| /^(.+?)_/.match(File.basename(f)).captures[0]}
          if !error

            begin
              log = ImportLog.create(number: DateTime.now.to_s(:number))
              log.message = "operation effectuée avec succés."
              log.save
              SmarterCSV.process(file.path, {:col_sep =>';', :chunk_size => 100, :key_mapping => {:sku_skuid=>:sku, :sku_available =>:qty , :sku_eds => :eds}}) do |chunk|
                ChaindriveController.process_chunk chunk, log.id
              end
            rescue Redis::CannotConnectError
              log.delete
              error = "Une erreur de connection est survenue"
            rescue StandardError
              error = "Une erreur inconnue estsurvenue"

            end

        if(:return_to)
          redirect_to session.delete(:return_to), :flash => error ? {:error =>error } : { :notice =>"operation effectuée avec succés." }
        else
          redirect_to ("/admin"), :flash =>error ? {:error =>error } : { :notice =>"operation effectuée avec succés." }
        end
          end
      end
      public
        def self.process_chunk chunk, log_id
          log = ImportLog.find(log_id)

          begin
          chunk.each do |row|
            variant = Spree::Variant.where(sku: row[:sku]).first
            puts row[:qty]
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

          if log.message ==  "operation en cours."
            log.message = "Opération effectuée avec succès"
            log.save
          end
        end
      end

  end


