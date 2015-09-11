
# This migration comes from spree (originally 20150707204155)
class AddQuantityOnHoldToStockItem < ActiveRecord::Migration
  def up
    add_column :spree_stock_items, :stock_on_hold, :integer, default:0
    Spree::StockItem.update_all(:stock_on_hold => 0)
  end

  def down
    remove_column :spree_stock_items, :stock_on_hold
  end
end
