require "pagination/version"

module Pagination
  class Engine < Rails::Engine; end

  module Base
    extend ActiveSupport::Concern

    module ClassMethods
      def pagination params
        page(params[:page]).per(params[:per_page])
      end
    end
  end
end
