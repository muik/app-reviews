require 'app-reviews/base_reviews'
require 'app-reviews/t_store/review_page'
require 'httpclient'

module AppReviews
  module TStore
    class Reviews
      include BaseReviews

      def each
        unless @list.nil?
          return @list.each do |item|
            yield item
          end
        end

        @list = []
        url = "http://www.tstore.co.kr/userpoc/multi/popReply.omp"
        params = {
          prodId: @app_id,
          currentPage: 0,
          flag: 'L',
          replyType: 0,
        }

        (@start_page..@end_page).each do |page|
          params[:currentPage] = page
          client = HTTPClient.new
          content = client.post_content(url, params.to_query)
          review_page = TStore::ReviewPage.new content, page
          break unless review_page.items do |item|
            return false if Date.strptime(item[:date], '%Y-%m-%d') < @from_date
            @list << item
            yield item
            true
          end
        end
      end
    end
  end
end
