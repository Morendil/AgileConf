require 'mechanize'

class Scraper02

  def initialize link
    @agent = Mechanize.new
    @page = @agent.get link
  end

  def [] symbol
    self.send symbol
  end

  def title
    @page./("span.orangeTitle").first.text
  end

  def stage
    "Main conference"
  end

  def speakers
    raw = @page./("span.orangeTitle")[1].text
    raw.gsub("by ","").split(",").map(&:strip)
  end

  def description
    @page./("/html/body/table[2]/tr[2]/td[2]/*[not(self::table)]").text.strip
  end

  def type
    @page./("span.brownTitle").first.text
  end

  def hash
    result = {}
    [:title,:description,:type,:speakers,:stage].each do |key|
      result[key]=self[key]
    end
    result
  end



end

