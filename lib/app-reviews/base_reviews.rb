module AppReviews
  module BaseReviews
    include Enumerable

    def set_last_date(date)
      @last_date = date
    end

    def last_date
      @last_date
    end

    def set_page(start_page, end_page)
      @start_page = start_page
      @end_page = end_page
    end

    def set_from_date(date)
      @from_date = date
    end

    def count
      @list.count
    end

    def last
      @list.last
    end

    private
    def initialize(app_id)
      @app_id = app_id
      @list = nil
    end
  end
end

