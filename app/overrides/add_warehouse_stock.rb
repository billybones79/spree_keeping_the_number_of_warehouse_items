Deface::Override.new(:virtual_path=>'spree/admin/products/stock',
                     :name => 'add_warehouse_stock',
                     :insert_after =>"erb[loud]:contains('item.count_on_hand')",
                     :text         =>"</td>
                        <td class='text-center'><%= item.warehouse_stock %>")