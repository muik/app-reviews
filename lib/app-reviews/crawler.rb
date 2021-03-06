# encoding: utf-8
require "app-reviews/version"
require 'active_support/core_ext'
require 'app-reviews'
require 'yaml'

module AppReviews
  class Crawler
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

      reviews = AppReviews.create(store, app_id)
      return print_usage unless reviews
      reviews.set_page start_page, end_page
      reviews.set_from_date from_date
      reviews.each do |item|
        puts item.to_yaml
      end

      puts "Review Count: #{reviews.count}"
      puts "Review Last Date: #{reviews.last[:date]}"
    end

    def create_reviews(store, app_id)
    end

    def validate(argv)
      return false if argv.size < 3
      true
    end

    def print_usage
      puts "USAGE: app-reviews-crawler appstore|play|tstore store_app_id from_date"
      puts "example# app-reviews-crawler appstore 383844387 2012-03-26"
      puts "example# app-reviews-crawler play com.thinkreals.pocketstyle2 2012-03-26"
      puts "example# app-reviews-crawler tstore 0000033534 2012-03-26"
    end
  end
end
