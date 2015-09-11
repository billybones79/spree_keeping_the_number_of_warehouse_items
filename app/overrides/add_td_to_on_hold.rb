Deface::Override.new(:virtual_path=>'spree/admin/products/stock',
                     :name => 'add_td_to_on_hold',
                     :insert_after =>"erb[loud]:contains('item.count_on_hand')",
                     :text         =>"</td>
                        <td class='text-center'><%= item.stock_on_hold %>",
                     :sequence => 99)