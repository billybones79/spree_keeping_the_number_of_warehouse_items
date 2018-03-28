class EmptyStockWorker
  include Sidekiq::Worker
  def perform(chunk, log_id)

    log = ImportLog.find(log_id)

    ActiveRecord::Base.delay_touching do

      ActiveRecord::Base.transaction do
        Spree::StockLocation.where(:default => true).first().stock_items.update_all(warehouse_stock: 0, count_on_hand: 0)
      end

      chunk.each_slice(100) do |chunk|

        ChaindriveWorker.perform_async( chunk, log.id)

      end
    end
  end
end