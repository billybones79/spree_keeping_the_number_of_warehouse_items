class ChaindriveWorker
  include Sidekiq::Worker
  def perform(chunk, log_id)

    log = ImportLog.find(log_id)

    begin

      ActiveRecord::Base.transaction do

        chunk.each do |row|
          variant = Spree::Variant.where(sku: row['sku']).first

          if variant && row['qty'].is_a?(Integer)
            location = Spree::StockLocation.where(:default => true).first()
            if location

              location.import_warehouse_item(variant, row['qty'], log)
            else
              log.message =  "Il n'y a pas de location par défaut, veuillez en sélectionner une."
              log.save
              break
            end
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