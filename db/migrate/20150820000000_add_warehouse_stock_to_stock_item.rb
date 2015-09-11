
# This migration comes from spree (originally 20150707204155)
class AddWarehouseStockToStockItem < ActiveRecord::Migration
  def up
    add_column :spree_stock_items, :warehouse_stock, :integer, default: 0
    Spree::StockItem.update_all(:warehouse_stock => 0)

  end

  def down
    remove_column :spree_stock_items, :warehouse_stock
  end
end
