module ScraperAdapter

  def [] symbol
    self.send symbol
  end

  def shift
    @index = number+1
    items.shift
    items.first
  end

  def number
    @index || 0
  end

  def items
    @items || (@items = fetch_items)
  end

  def hash
    result = {}
    [:title,:description,:type,:speakers,:stage,:records].each do |key|
      result[key]=self[key]
    end
    result
  end

  def marker
    items.first
  end

end
