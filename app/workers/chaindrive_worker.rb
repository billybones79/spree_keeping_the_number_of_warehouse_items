class ChaindriveWorker
  include Sidekiq::Worker
  def perform(chunk, log_id)

    log = ImportLog.find(log_id)


      ActiveRecord::Base.transaction do
        begin
          chunk.each do |row|
            variant = Spree::Variant.where(sku: row['sku']).first

            if variant && !variant.is_master? && row['qty'].is_a?(Integer)
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
        rescue => error
          puts error.inspect
        end
      end
  end



end