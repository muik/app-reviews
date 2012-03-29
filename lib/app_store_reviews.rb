require 'base_app_reviews'
require 'app_store_review_page'
require 'httpclient'
require 'open-uri'

class AppStoreReviews
  include BaseAppReviews

  def each
    unless @list.nil?
      return @list.each do |item|
        yield item
      end
    end

    @list = []
    country_codes = [143441, 143466, 143463]
    country_codes.each do |country_code| 
      get_reviews(country_code) do |review|
        @list << review
        yield review
      end
    end
  end

  private
  def get_reviews(country)
    (@start_page..@end_page).each do |page|
      url = "http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?sortOrdering=4&onlyLatestVersion=false&sortAscending=true&pageNumber=#{(page - 1)}&type=Purple+Software&id=#{@app_id}"

      f = open(url,	"User-Agent" => "iTunes-iPhone/2.2 (2)", "X-Apple-Store-Front" => "#{country}-1") 
#      File.new('review.xml', 'w').puts f.read
#      exit
      review_page = AppStoreReviewPage.new f.read, page
      break unless review_page.items do |item|
        return false if Date.parse(item[:date]) < @from_date
        yield item
        true
      end

      break if review_page.last_page < page + 1
    end
  end
end

