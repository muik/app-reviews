require 'nokogiri'
require 'rexml/document'
include REXML

module AppReviews
  module AppStore
    class ReviewPage
      def initialize(text, page)
        @doc = Nokogiri::XML(text)
        @page = page
      end

      def items
        path = "Document > View > ScrollView > VBoxView > View > MatrixView > VBoxView > VBoxView > VBoxView"
        @doc.css(path).each do |link|
          begin
            review = parse link
            next if review.nil?
            break unless yield review
          rescue Exception => e
            print_parse_error e, link
          end
        end
      end

      def last_page
        @doc.css("MatrixView > VBoxView > VBoxView > HBoxView:nth-child(2) > TextView > SetFontStyle").each do |link|
          link.content.split(' ').last.to_i 
        end
      end

      private
      def parse(link)
        node = link.css('TextView > SetFontStyle')
        date = node[2].content.gsub("\n", '').strip
        index = date.rindex('- ')
        return if index.nil?
        index += 1
        date = date[index..-1].strip
        name_el = node.css('GotoURL > b')
        title_el = node[0].css('b')
        name = name_el.first.content.strip
        title = title_el.first.content
        text = node[3].content.strip
        node = link.css('HBoxView > HBoxView > HBoxView')
        rating = node.attr('alt').value

        {
          title: title,
          name: name,
          text: text,
          rating: rating,
          date: date,
        }
      end

      def print_parse_error(e, link)
        puts e
        puts e.backtrace
        puts "page: #{@page}"
        puts link
      end
    end
  end
end

