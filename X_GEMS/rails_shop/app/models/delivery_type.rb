class DeliveryType < ActiveRecord::Base
  include ImageTools
  include ::RailsShop::MainImage
  include ::RailsShop::StatesProcessing

  include ::SimpleSort::Base
  include ::Pagination::Base
  include ::Notifications::LocalizedErrors

  include PublicationContentProcessing

  paginates_per 15

  belongs_to :user

  KINDS = %w[ forein domestic local pickup special ]

  KINDS.each do |kind|
    scope kind, ->{ where delivery_kind: kind }

    define_method "#{ kind }?" do
      self.delivery_kind.to_s == kind.to_s
    end
  end

  validates_inclusion_of :delivery_kind, in: KINDS
  validates_presence_of :user, :title

  scope :default_option, ->{ where(default_option: true).published.recent }
end
