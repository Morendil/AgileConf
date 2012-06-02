require 'mechanize'

class Scraper02

  def initialize link
    @agent = Mechanize.new
    @page = @agent.get link
  end

  def title
    @page./("span.orangeTitle").first.text
  end

  def speakers
    raw = @page./("span.orangeTitle")[1].text
    raw.gsub("by ","").split(",").map(&:strip)
  end

  def description
    @page./("/html/body/table[2]/tr[2]/td[2]").text
  end

  def type
    @page./("span.brownTitle").first.text
  end

end