Spree::OrderInventory.class_eval do



  def remove_from_shipment(shipment, quantity)
    return 0 if quantity == 0 || shipment.shipped?

    shipment_units = shipment.inventory_units_for_item(line_item, variant).reject do |variant_unit|
      variant_unit.state == 'shipped'
    end.sort_by(&:state)

    removed_quantity = 0

    shipment_units.each do |inventory_unit|
      break if removed_quantity == quantity
      inventory_unit.destroy
      removed_quantity += 1
    end

    shipment.destroy if shipment.inventory_units.count == 0

    # removing this from shipment, and adding to stock_location
    if order.completed?
      shipment.stock_location.restock_on_hold variant, removed_quantity, shipment
    end

    removed_quantity
  end

  def add_to_shipment(shipment, quantity)
    if variant.should_track_inventory?
      on_hand, back_order = shipment.stock_location.fill_status(variant, quantity)

      on_hand.times { shipment.set_up_inventory('on_hand', variant, order, line_item) }
      back_order.times { shipment.set_up_inventory('backordered', variant, order, line_item) }
    else
      quantity.times { shipment.set_up_inventory('on_hand', variant, order, line_item) }
    end

    # adding to this shipment, and removing from stock_location
    if order.completed?
      shipment.stock_location.unstock_on_hold(variant, quantity, shipment)
    end

    quantity
  end

end
