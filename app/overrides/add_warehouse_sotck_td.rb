Deface::Override.new(:virtual_path=>'spree/admin/products/stock',
                     :name => 'add_warehouse_stock_td',
                     :insert_after =>"erb[loud]:contains('t(:count')",
                     :text         =>"</th><th><%= Spree.t(:warehouse_stock) %>")