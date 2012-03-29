require 'rexml/document'
include REXML

module AppReviews
  module TStore
    class ReviewPage
      def initialize(content, page)
        content = content.gsub(/<textarea[^<]+<\/textarea>/, '')
        content = content.gsub('gif""', 'gif"')
        xml = Document.new(content)
        @table = xml.root.elements['body'].elements[2, 'form'].elements[2, 'div'].elements['table']
      end

      def items
        @table.elements.each do |item|
          begin
            td = item.elements['td']
            next unless td
            date = td.elements['p'].elements['span'].text.strip
            name = td.elements['p'].elements[2, 'strong'].text.strip
            text = td.elements[2, 'p'].elements['span'].elements['div'].text.gsub('&nbsp;', ' ').strip
            review = {
              text: text,
              name: name,
              date: date,
            }
            break unless yield review
          rescue Exception => e
            print_error e, item
          end
        end
      end

      private
      def print_error(e, item)
        puts e
        puts e.backtrace
        puts "page: #{@page}"
        puts item
      end
    end
  end
end

