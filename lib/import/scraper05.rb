require 'mechanize'

require "./lib/import/scraper_adapter.rb"

class Scraper05
  include ScraperAdapter

  def initialize stage
    @stage = stage
    @agent = Mechanize.new
    @page = @agent.get "#{archive}http://www.agile2005.org/track/#{stage}"
  end

  def archive
    "http://web.archive.org/web/20060106194738/"
  end

  def fetch_items
    @page./("/html/body/table/tr[2]/td[2]/table/tr/td/a/@name").map(&:text)
  end

  def anchor
    @page.at("/html/body/table/tr[2]/td[2]/table/tr/td/a[@name='#{marker}']")
  end

  def title
    anchor.text.gsub(/\n|\t|\r/,"").gsub(/ +/," ")
  end

end
