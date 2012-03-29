# encoding: utf-8
require "app-reviews-crawler/version"
require 'app_store_reviews'
require 'play_store_reviews'
require 'tstore_reviews'
require 'active_support/core_ext'

class AppReviewsCrawler
  def execute(argv)
    return print_usage unless validate argv
    store, app_id, from_date_str = argv
    start_page = 1
    end_page = 10000
    from_date = Date.parse(from_date_str)
    puts "store: #{store}"
    puts "app_id: #{app_id}"
    puts "from_date: #{from_date}"
    puts "page: #{start_page} ~ #{end_page}"

    reviews = create_reviews(store, app_id)
    return print_usage unless reviews
    reviews.set_page start_page, end_page
    reviews.set_from_date from_date
    require 'yaml'
    reviews.each do |item|
      puts item.to_yaml
    end

    puts "Review Count: #{reviews.count}"
    puts "Review Last Date: #{reviews.last[:date]}"
  end

  def create_reviews(store, app_id)
    case store
    when 'appstore'
      AppStoreReviews.new app_id
    when 'play'
      PlayStoreReviews.new app_id
    when 'tstore'
      TstoreReviews.new app_id
    end
  end

  def validate(argv)
    return false if argv.size < 3
    true
  end

  def print_usage
    puts "USAGE: app-reviews-crawler appstore|play|tstore store_app_id from_date"
  end
end
