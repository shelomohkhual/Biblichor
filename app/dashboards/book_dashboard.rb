require "administrate/base_dashboard"

class BookDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    owner: Field::BelongsTo,
    renter: Field::BelongsTo,
    rate: Field::HasMany,
    genre: Field::String,
    front_cover_attachment: Field::HasOne,
    front_cover_blob: Field::HasOne,
    back_cover_attachment: Field::HasOne,
    back_cover_blob: Field::HasOne,
    features_attachments: Field::HasMany.with_options(class_name: "ActiveStorage::Attachment"),
    features_blobs: Field::HasMany.with_options(class_name: "ActiveStorage::Blob"),
    id: Field::Number,
    title: Field::String,
    author: Field::String,
    published_date: Field::DateTime,
    description: Field::Text,
    genre: Field::String,
    front_cover: Field::String,
    back_cover: Field::String,
    features: Field::String,
    renting: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    price: Field::Number.with_options(decimals: 2),
    owner_name: Field::String,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :owner,
    :renter,
    :rate,
    :genre,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :owner,
    :renter,
    :rate,
    :genre,
    :front_cover_attachment,
    :front_cover_blob,
    :back_cover_attachment,
    :back_cover_blob,
    :features_attachments,
    :features_blobs,
    :id,
    :title,
    :author,
    :published_date,
    :description,
    :genre,
    :front_cover,
    :back_cover,
    :features,
    :renting,
    :created_at,
    :updated_at,
    :price,
    :owner_name,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :owner,
    :renter,
    :rate,
    :genre,
    :front_cover_attachment,
    :front_cover_blob,
    :back_cover_attachment,
    :back_cover_blob,
    :features_attachments,
    :features_blobs,
    :title,
    :author,
    :published_date,
    :description,
    :genre,
    :front_cover,
    :back_cover,
    :features,
    :renting,
    :price,
    :owner_name,
  ].freeze

  # Overwrite this method to customize how books are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(book)
  #   "Book ##{book.id}"
  # end
end
