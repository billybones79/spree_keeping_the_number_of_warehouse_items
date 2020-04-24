Spree::StockLocation.class_eval do
  def unstock_on_hold(variant, quantity, originator = nil)
    move(variant, -quantity, originator)
    put_on_hold(variant, quantity)
  end

  def restock_on_hold(variant, quantity, originator = nil)
    move(variant, quantity, originator)
    remove_on_hold(variant, quantity)
  end

  def put_on_hold(variant, quantity)
    stock_item_or_create(variant).update_stock_on_hold(quantity);
  end

  def remove_on_hold(variant, quantity)
    stock_item_or_create(variant).update_stock_on_hold(-quantity);
  end

  def remove_from_warehouse(variant, quantity, originator = nil)
    stock_item_or_create(variant).update_warehouse_stock(-quantity);
  end

  def restock(variant, quantity, originator = nil)
    puts "restock"
    puts quantity
    move(variant, quantity, originator)
  end

  def move(variant, quantity, originator = nil)


    stock_item_or_create(variant).stock_movements.create!(quantity: quantity,
                                                          originator: originator)
  end

  def import_warehouse_item(variant, quantity, originator =nil)

    stock_item =  stock_item_or_create(variant)

    # on va se mettre le minimum entre la nouvelle quantité, ou la différence entre l'ancien warehousestock et le nouveau, car il est
    # problable que on aie plus de warehouse_stock que de on_hand, mais pas l'inverse
    diff = [quantity - stock_item.warehouse_stock, quantity - (stock_item.count_on_hand + stock_item.stock_on_hold)].min


    if diff>0
        restock(variant,diff, originator)
    elsif stock_item.count_on_hand + diff > 0 && diff !=0
         unstock(variant, -diff, originator)
    elsif diff !=0
         unstock(variant, stock_item.count_on_hand, originator)
    end
    stock_item.set_warehouse_stock(quantity)
  end

  def revert_warehouse_item(stock_movement, originator)
    diff = -stock_movement.quantity
    stock_item = stock_movement.stock_item

    quantity = [stock_item.warehouse_stock + diff, stock_item.count_on_hand+diff+stock_item.stock_on_hold].max
    stock_item.set_warehouse_stock(quantity)


    if diff>0
      restock(stock_item.variant,diff, originator)
    elsif stock_item.count_on_hand + diff > 0 && diff !=0
      unstock(stock_item.variant, -diff, originator)
    else
      unstock(stock_item.variant, stock_item.count_on_hand, originator)
    end


  end

end
