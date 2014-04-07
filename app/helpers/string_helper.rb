module StringHelper
  def humanize(str)
    str.try { |s| s.to_s.humanize }
  end
end
