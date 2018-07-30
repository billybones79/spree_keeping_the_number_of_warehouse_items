class EmptyStockWorker
  include Sidekiq::Worker
  def perform(chunk, log_id)

    log = ImportLog.find(log_id)

    ActiveRecord::Base.delay_touching do

      ActiveRecord::Base.transaction do
        Spree::StockLocation.where(:default => true).first().stock_items.where.not(variant_id: Spree::Variant.where(sku: (chunk.map { |el| el["sku"] } )).pluck(:id)).update_all(warehouse_stock: 0, count_on_hand: 0)
      end

      chunk.each_slice(300).with_index do |chunk, i|

        ChaindriveWorker.perform_at(Time.now + (i*6).seconds, chunk, log.id)

      end
    end
  end
end