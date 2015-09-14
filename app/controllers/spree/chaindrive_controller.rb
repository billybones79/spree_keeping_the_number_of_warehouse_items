module Spree
    class ChaindriveController < Spree::Admin::BaseController
      def import
          log = ImportLog.new(number: DateTime.now.to_s(:number))

          session[:return_to] ||= request.referer
          file = params[:chaindrive_file].tempfile

          if(File.extname(file.path) != ".csv" )
            error = "mauvais type de fichier"+File.extname(file.path)
          end

          #Dir.glob("*").max_by{|f| /^(.+?)_/.match(File.basename(f)).captures[0]}
          if !error
            begin
              sku_qty = SmarterCSV.process(file.path, {:col_sep =>';', :chunk_size => 100, :key_mapping => {:sku_skuid=>:sku, :sku_available =>:qty , :sku_eds => :eds}}) do |chunk|
                chunk.each do |row|
                  variant = Spree::Variant.where(sku: row[:sku]).first
                  if variant && row[:qty].is_a?(Integer)
                    location = Spree::StockLocation.where(:default => true).first()
                    if isset(location)
                      location.import_warehouse_item(variant, row[:qty], log)
                    else
                      error = "Il n'y a pas de location par défaut, veuillez en sélectionner une."
                      break
                    end
                  end
                end
              end
            rescue Exception

              error = "structure du fichier invalide"
             end


            if !error
              success = "operation effectuée avec succès."
            end
          end

        if(:return_to)
          redirect_to session.delete(:return_to), :flash => { :error => error, :notice =>success }
        else
          redirect_to ("/admin"), :flash => { :error => error, :success =>success }
        end
      end
    end
  end


