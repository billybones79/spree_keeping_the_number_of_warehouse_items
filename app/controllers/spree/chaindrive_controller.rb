module Spree
    class ChaindriveController < Spree::Admin::BaseController
      def import
          log = ImportLog.create(number: DateTime.now.to_s(:number))

          session[:return_to] ||= request.referer
          file = params[:chaindrive_file].tempfile

          if File.extname(file.path) != ".csv"
            error = log.message = "mauvais type de fichier : "+File.extname(file.path)
          end

          #Dir.glob("*").max_by{|f| /^(.+?)_/.match(File.basename(f)).captures[0]}
          if !error

              sku_qty = SmarterCSV.process(file.path, {:col_sep =>';', :chunk_size => 100, :key_mapping => {:sku_skuid=>:sku, :sku_available =>:qty , :sku_eds => :eds}}) do |chunk|
                error = ChaindriveController.delay.process_chunk chunk, log.id
              end
            if !error
              log.message = "operation effectuée avec succès."
            end
          end

        if(:return_to)
          redirect_to session.delete(:return_to), :flash => { :notice =>"operation en cours." }
        else
          redirect_to ("/admin"), :flash => { :notice =>"operation en cours." }
        end
      end
      public
        def self.process_chunk chunk, log_id
          log = ImportLog.find(log_id)

          chunk.each do |row|
            variant = Spree::Variant.where(sku: row[:sku]).first
            if variant && row[:qty].is_a?(Integer)
              location = Spree::StockLocation.where(:default => true).first()
              if location
                location.import_warehouse_item(variant, row[:qty], log)
              else
                error = log.message =  "Il n'y a pas de location par défaut, veuillez en sélectionner une."
                break
              end
            end
          end

          
        end
    end
  end


