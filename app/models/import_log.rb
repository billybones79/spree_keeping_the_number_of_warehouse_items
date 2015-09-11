
    class ImportLog < Spree::Base
      has_many :stock_movements, as: :originator, :class_name =>'Spree::StockMovement';
    end


