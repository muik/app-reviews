require 'httpclient'
require 'tstore_review_page'

class TstoreReviews
  include BaseAppReviews

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
      review_page = TstoreReviewPage.new content, page
      break unless review_page.items do |item|
        return false if Date.strptime(item[:date], '%Y-%m-%d') < @from_date
        @list << item
        yield item
        true
      end
    end
  end
end

