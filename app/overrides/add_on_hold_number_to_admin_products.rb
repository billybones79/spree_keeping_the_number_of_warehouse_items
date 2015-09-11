Deface::Override.new(:virtual_path=>'spree/admin/products/stock',
:name => 'add_on_hold_number_to_admin_products',
:insert_after =>"erb[loud]:contains('t(:count')",
:text         =>"</th><th><%= Spree.t(:stock_on_hold) %>",
 :sequence => 99)