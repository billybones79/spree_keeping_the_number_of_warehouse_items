Spree::StockMovement.class_eval do
  before_create  :set_quantity_before
  after_create :update_stock_item_quantity

  private
  def set_quantity_before

    begin
      self.quantity_before = self.stock_item.count_on_hand
    rescue StandardError => e
      puts e.inspect
    end

    begin
      return unless self.stock_item.should_track_inventory?
      stock_item.adjust_count_on_hand quantity

      self.quantity_after = self.stock_item.count_on_hand

    rescue StandardError => e
      puts e.inspect
    end
  end

  def update_stock_item_quantity
  end
end