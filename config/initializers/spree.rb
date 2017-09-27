Spree::Backend::Config.menu_items <<
    Spree::BackendConfiguration::MenuItem.new(
        [:lautopak, :import, :import_logs],
        'th-large',
        url: "#",
        condition: -> { can?(:admin, Spree::Product) },
        partial: 'spree/admin/shared/lautopak_sub_menu'
    )
