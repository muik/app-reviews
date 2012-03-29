require 'app-reviews/app_store/reviews'
require 'app-reviews/play_store/reviews'
require 'app-reviews/t_store/reviews'

module AppReviews
  def self.create(store, app_id)
    case store
    when 'appstore'
      AppStore::Reviews.new app_id
    when 'play'
      PlayStore::Reviews.new app_id
    when 'tstore'
      TStore::Reviews.new app_id
    end
  end
end
