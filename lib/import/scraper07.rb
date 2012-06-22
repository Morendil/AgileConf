require 'mechanize'

require "./lib/import/scraper_adapter.rb"

class Scraper07
  include ScraperAdapter

  def initialize link
    @agent = Mechanize.new
    @page = @agent.get link
  end

  def detail id
    "http://agile2007.agilealliance.org/index.php%3Fpage=sub%252F&id=#{id}.html"
  end

  def fetch_items
    items = @page./("div[@class='content']/div/h1/a/@href")
    items.map {|each| (each.text.match /(\w+)(?:.html)/)[1]}
  end

  def id
    marker.to_i
  end

  def title
    @page.at("div[@class='content'][#{number+1}]/div/h1/a/text()").text.strip
  end

  def description
    subpage = @agent.get (detail marker)
    subpage./("span[@class='abstract']").map(&:text).map(&:strip).join("\n")
  end

  def type
    result = "Other"
    type = @page.at("div[@class='content'][#{number+1}]/div/h3/a[1]/text()")
    result = type.text.strip if type
    result = result[0..-2] if result.end_with? "s"
    result = "Workshop" if result == "Hands On"
    result
  end

  def stage
    result = "Main"
    type = @page.at("div[@class='content'][#{number+1}]/div/h3/a[2]/text()")
    result = type.text.strip if type
    result
  end

  def speakers
    names = @page./("div[@class='content'][#{number+1}]/div/h4/a/text()")
    names.map(&:text).map(&:strip)
  end

  def records
    domain = "http://agile2007.agilealliance.org/"
    links = @page./("div[@class='content'][#{number+1}]/div/h3/h3/a/@href")
    links.map(&:text).map(&:strip).map {|each| domain + each}
  end

end
