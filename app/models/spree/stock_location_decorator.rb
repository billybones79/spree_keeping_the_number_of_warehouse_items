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

    puts caller(0)
    move(variant, quantity, originator)
  end

  def import_warehouse_item(variant, quantity, originator =nil)
    puts variant.inspect
    variant =  stock_item_or_create(variant)

    # on va se mettre le minimum entre la nouvelle quantité, ou la différence entre l'ancien warehousestock et le nouveau, car il est
    # problable que on aie plus de warehouse_stock que de on_hand, mais pas l'inverse
    diff = [quantity - variant.warehouse_stock, quantity - variant.count_on_hand].min

    if diff>0
        restock(variant,diff, originator)
    elsif variant.count_on_hand + diff > 0
         unstock(variant, -diff, originator)
    else
         unstock(variant, variant.count_on_hand, originator)
    end
    variant.set_warehouse_stock(quantity)
  end

end