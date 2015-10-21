
class AddBeforeAndAfterToStockMovement < ActiveRecord::Migration
  def up
    add_column :spree_stock_movements, :quantity_after, :integer
    add_column :spree_stock_movements, :quantity_before, :integer



  end

  def down
    remove_column :spree_stock_movements, :quantity_after
    remove_column :spree_stock_movements, :quantity_before

  end
end
