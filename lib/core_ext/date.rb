class Date
  def fiscal_year
    if self.month >= 7
      self.year
    else
      self.year - 1
    end
  end
end