class Date
  def fiscal_year
    if self.month >= 7
      self.year + 1
    else
      self.year
    end
  end
end