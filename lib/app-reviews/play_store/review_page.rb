# encoding: utf-8
require 'rexml/document'
include REXML

module AppReviews
  module PlayStore
    class ReviewPage
      def initialize(text, page)
        result = JSON(text[5..-1])
        html = result['htmlContent'].gsub('<hr>', '<hr />')
        @xml = Document.new("<body>#{html}</body>")
        @page = page
      end

      def items
        @xml.root.elements.each do |item|
          next if item.elements.size < 1
          begin
            name_el = item.elements['span'].elements['strong']
            next unless name_el
            date = item.elements[2, 'span'].text.sub('님이', '').strip

            title = item.elements['div'].elements['h4'].text.strip
            if item.elements['p']
              text = item.elements['p'].text 
            else
              text = nil
            end
            text = text.strip if text
            name = name_el.text.strip
            rating = item.elements['div'].elements['div'].attribute('title').value.strip
            review = {
              title: title,
              text: text,
              name: name,
              rating: rating,
              date: date,
            }
            break unless yield review
          rescue Exception => e
            print_error e, item
          end
        end
      end

      def print_error(e, item)
        puts e
        puts e.backtrace
        puts "page: #{@page}"
        puts item
      end
    end
  end
end

