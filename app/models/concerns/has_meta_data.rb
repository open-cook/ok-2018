module HasMetaData
  extend ActiveSupport::Concern

  included do
    after_save :create_meta_data_object
    has_one :meta_data, as: :holder

    private

    def create_meta_data_object
      MetaData.create(holder: self) unless self.meta_data
    end
  end
end
