module DateHelper
  def nice_date_for(time)
    time.try { |t| t.to_date.to_formatted_s(:long) }
  end
end
