
    class ImportLog < Spree::Base
      has_many :stock_movements, as: :originator, :class_name =>'Spree::StockMovement';

      has_many :reverters, class_name: "ImportLog", foreign_key: "reverted_id"
      belongs_to :reverted, class_name: "ImportLog"

      def is_reverted?
       return reverters.any?
      end

      def last_reverter
        return reverters.last
      end

      def revert
        revert_log = ImportLog.create(number: DateTime.now.to_s(:number), filename: 'revert "'+self.filename+'"', reverted_id: self.id)

        self.stock_movements.each do |movement|
            movement.stock_item.stock_location.revert_warehouse_item(movement, revert_log)
        end
      end

    end


