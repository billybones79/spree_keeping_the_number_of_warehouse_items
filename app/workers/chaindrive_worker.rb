class ChaindriveWorker
  include Sidekiq::Worker
  def self.perform(chunk, log_id)
    byebug
    log = ImportLog.find(log_id)

    ActiveRecord::Base.delay_touching do

      ActiveRecord::Base.transaction do
        chunk.each do |row|
          byebug
          variant = Spree::Variant.where(sku: row[:sku]).first

          if variant && !variant.is_master? && row[:qty].is_a?(Integer)
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
      end
    end
  end
end