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

  def contents
    "/html/body/table/tr[2]/td[2]/table"
  end

  def fetch_items
    case @stage
      when "experience_reports", "educators_symposium" then
        @page./("#{contents}/tr/td[@class='title']").map(&:text)
      else @page./("#{contents}/tr/td/a/@name").map(&:text)
    end
  end

  def anchor
    case @stage
      when "experience_reports", "educators_symposium" then
        @page./("#{contents}/tr/td[@class='title']")[number].children.first
      else @page.at("#{contents}/tr/td/a[@name='#{marker}']")
    end
  end

  def type
    case @stage
      when "tutorials" then "Tutorial"
      when "experience_reports" then "Experience Report"
      when "workshops" then "Workshop"
      when "research_papers" then "Research Paper"
      when "educators_symposium" then "Educator Paper"
      when "intro_to_agile" then "Tutorial"
      else "Talk"
    end
  end

  def stage
    case @stage
      when "tutorials" then "Tutorials"
      when "experience_reports" then "Experience Reports"
      when "workshops" then "Workshops"
      when "research_papers" then "Research Papers"
      when "educators_symposium" then "Educator's Symposium"
      when "intro_to_agile" then "Introduction to Agile"
      else "Main"
    end
  end

  def code
    case @stage
      when "tutorials" then "TU"
      when "experience_reports" then "XR"
      when "workshops" then "WK"
      when "research_papers" then "RP"
      when "educators_symposium" then "ES"
      when "intro_to_agile" then "INTRO"
      else "XX"
    end
  end

  def title
      anchor./("..//text()").map(&:text).join(" ").gsub(/\n|\t|\r/,"").gsub(/ +/," ").strip
  end

  def description
    looking = anchor.parent.parent
    begin
      looking = looking.next_sibling
    end while looking and not looking.text.start_with?("Abstract")
    looking.text[9..-1].strip if looking
  end

  def speakers
    looking = anchor.parent.parent
    begin
      looking = looking.next_sibling
    end while looking and looking./("td[class='captionLeft']").empty?
    speakers = looking./("td[class='captionLeft']/text()").map do |each|
      each.text.split(/[:,]/).first.strip
    end if looking
  end

  def all_records
    @all_records || @all_records = File.readlines("data/Agile2005-files.txt")
  end

  def records
    id = "#{code}#{number+1}"
    result = all_records.select {|each| each.start_with? "#{id} "}
    result.map &:strip
  end

end
