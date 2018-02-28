class MetaData < ActiveRecord::Base
  include SimpleSort::Base
  include Pagination::Base
  belongs_to :holder, polymorphic: true
end
