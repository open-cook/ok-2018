module MainFeedCtrl
  module Base
    private

    def add_pub_in_main_feed pub
      if MainFeed.suitable_for?(pub)
        MainFeed.create(
          publication: pub,
          state: pub.state,
          moderation_state: pub.moderation_state
        )
      end
    end

    def update_main_feed pub
      if pub.main_feed
        pub.main_feed.update_columns(
          state: pub.state,
          moderation_state: pub.moderation_state
        )
      end
    end

    def destroy_main_feed pub
      pub.main_feed.destroy if pub.main_feed
    end
  end
end

