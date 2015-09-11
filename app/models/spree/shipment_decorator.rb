Spree::Shipment.class_eval do

  def finalize!
    Spree::InventoryUnit.finalize_units!(inventory_units)
    manifest.each { |item| manifest_unstock_on_hold(item) }
  end

  def manifest_unstock_on_hold(item)
    stock_location.unstock_on_hold item.variant, item.quantity, self
  end


  private
    def after_ship
      manifest.each { |item| stock_location.remove_from_warehouse item.variant, item.quantity, self
                              stock_location.remove_on_hold item.variant, item.quantity}
      Spree::ShipmentHandler.factory(self).perform
    end

  def after_cancel
    manifest.each { |item| manifest_restock(item)
                           stock_location.remove_on_hold item.variant, item.quantity}
  end
end