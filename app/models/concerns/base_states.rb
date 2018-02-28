module BaseStates
  extend ActiveSupport::Concern

  included do
    state_machine :state, :initial => :draft do
      # events
      event :to_draft do
        transition all => :draft
      end

      event :to_published do
        transition all => :published
      end

      event :to_deleted do
        transition all => :deleted
      end

      # cache counters
      # TODO: check for callback execution
      # try to replace increment/decrement methods with something else
      after_transition [:draft, :deleted] => :published do |obj|
        plural = obj.class.to_s.tableize
        field  = "#{ plural }_count"
        obj.user.increment!(field) if obj.user.respond_to?(field)
      end

      after_transition :published => [:draft, :deleted] do |obj|
        plural = obj.class.to_s.tableize
        field  = "#{ plural }_count"
        obj.user.decrement!("#{ plural }_count") if obj.user.respond_to?(field)
      end

      after_transition any => any do |obj|
        obj.try :recalculate_comments_counters!
        obj.try :send, :denormalize_for_comments

        if obj.respond_to?(:hub) && obj.try(:hub)
          obj.hub.recalculate_pubs_counters!
        end
      end

    end
  end
end
