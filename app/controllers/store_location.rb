class Spree::StoreLocation < Spree::Base

  extend FriendlyId
  friendly_id :city, :use => [:slugged, :finders]

  scope :not_primary, -> { where is_primary: false }
  scope :primary, -> { where is_primary: true }

  has_many :store_assets, -> { order(:created_at) }, dependent: :destroy, class_name: "Spree::StoreAsset"
  has_many :store_openings, dependent: :destroy, class_name: "Spree::StoreOpening"
  has_many :business_hours, dependent: :destroy, class_name: "Spree::BusinessHour"

  self.whitelisted_ransackable_attributes = %w[postal code street_address city phone]

  translates :postal_code, :street_address, :city, :phone, fallbacks_for_empty_translations: true

end
