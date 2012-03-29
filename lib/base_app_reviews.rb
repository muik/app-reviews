module BaseAppReviews
  include Enumerable

  def initialize(app_id)
    @app_id = app_id
    @list = nil
  end

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

  def last
    @list.last
  end
end

