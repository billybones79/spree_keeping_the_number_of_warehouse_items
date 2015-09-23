Spree::StockItem.class_eval do

  validates_numericality_of :stock_on_hold,
                            greater_than_or_equal_to: 0,
                            less_than_or_equal_to: 2**31 - 1,
                            only_integer: true, if: :verify_count_on_hand?

  validates_numericality_of :warehouse_stock,
                            less_than_or_equal_to: 2**31 - 1,
                            only_integer: true, if: :verify_count_on_hand?


  def update_stock_on_hold(quantity)
    self.with_lock do
      self.stock_on_hold = self.stock_on_hold + quantity
      self.save!
    end
  end

  def set_stock_on_hold(quantity)
    self.with_lock do
      self.stock_on_hold = quantity
      self.save!
    end
  end

  def update_warehouse_stock(quantity)
    self.with_lock do
      self.warehouse_stock = self.warehouse_stock + quantity
      self.save!
    end
  end

  def set_warehouse_stock(quantity)
    self.with_lock do
      self.warehouse_stock = quantity
      self.save!
    end
  end

end