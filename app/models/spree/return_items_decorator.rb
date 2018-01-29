Spree::ReturnItem.class_eval do

  def process_inventory_unit!
    inventory_unit.return!

    if should_restock?
      Spree::StockMovement.create!(stock_item_id: stock_item.id, quantity: 1)
      stock_item.update_warehouse_stock(1)
    end
  end

end