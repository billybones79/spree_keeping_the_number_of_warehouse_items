Spree::Backend::Config.menu_items <<
    Spree::BackendConfiguration::MenuItem.new(
        [:autopak, :import, :import_logs],
        'th-large',
        url: "#",
        condition: -> { can?(:admin, Spree::Product) },
        partial: 'spree/admin/shared/autopak_sub_menu'
    )
