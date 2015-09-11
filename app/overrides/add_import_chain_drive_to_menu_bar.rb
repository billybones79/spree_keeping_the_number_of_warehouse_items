Deface::Override.new(:virtual_path=>'spree/admin/shared/_main_menu',
                     :name => 'add_import_chain_drive_to_menu_bar',
                     :insert_after =>"erb[silent]:contains('current_store')~erb[silent]",
                     :text         =>"<ul class='nav nav-sidebar'>
                                        <%= main_menu_tree Spree.t(:chaindrive_import), icon: 'gift', sub_menu: 'chaindrive', url: '#sidebar-chaindrive' %>

                                     </ul>")