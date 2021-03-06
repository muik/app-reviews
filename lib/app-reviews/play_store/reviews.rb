# encoding: utf-8
require 'app-reviews/base_reviews'
require 'app-reviews/play_store/review_page'
require 'httpclient'

module AppReviews
  module PlayStore
    class Reviews
      include BaseReviews

      def each
        unless @list.nil?
          return @list.each do |item|
            yield item
          end
        end

        @list = []
        url = "https://play.google.com/store/getreviews"
        params = {
          id: @app_id,
          reviewSortOrder: 0,
          reviewType: 1,
          pageNum: 0,
        }

        (@start_page..@end_page).each do |page|
          params[:pageNum] = page - 1
          client = HTTPClient.new
          content = client.post_content(url, params.to_query)
          review_page = PlayStore::ReviewPage.new content, page
          break unless review_page.items do |item|
            return false if Date.strptime(item[:date], '%Y년 %m월 %d일') < @from_date
            @list << item
            yield item
            true
          end
        end
      end
    end
  end
end
