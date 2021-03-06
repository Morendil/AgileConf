require 'mechanize'

class Scraper03

  def initialize stage
    @stage = stage
    @agent = Mechanize.new
    @page = @agent.get "http://agile2003.agilealliance.org/schedule/#{stage}.html"
  end

  def shift
    items.shift
    items.first
  end

  def hash
    result = {}
    [:title,:description,:type,:speakers,:stage,:records].each do |key|
      result[key]=self[key]
    end
    result
  end

  def [] symbol
    self.send symbol
  end

  def items
    @items || (@items = fetch_items)
  end

  def fetch_items
    xpath = "/html/body/table/tr[3]/td[2]/table[2]/tr/td/table[1]/tr/td/table/tr/td[1]"
    @page./(xpath).map(&:text)[1..-1]
  end

  def marker
    items.first
  end

  def anchor
    m = marker
    m = "T#{marker}" if m[0] == "E"
    xpath = "/html/body/table/tr[3]/td[2]/table[2]/tr/td/table[3]/tr/td[1]/a[@name='#{m}']"
    @page./(xpath).first
  end

  def title
    anchor.parent.next_element().at("b/text()").to_s.strip
  end

  def speakers
    all = anchor.parent.next_element().at("b/text()[2]").to_s.strip
    all.split(/(?: &amp; )|(?:<br>)/).map {|each| each.split(",").first}
  end

  def description
    anchor.parent.parent.next_element.at("td[2]").text.gsub("\t","")
  end

  def records
    xpath = "/html/body/table/tr[3]/td[2]/table[2]/tr/td/table[1]/tr/td/table/tr[td[1]/text()='#{marker}']/td[4]/table/tr/td/a/@href"
    links = @page./(xpath).map(&:text)
    links.map {|each| each.gsub("..","http://agile2003.agilealliance.org")}
  end

  def stage
    case @stage
      when "tutorials" then "Tutorials"
      when "researchpapers" then "Research"
      when "experiencereports" then "Experience Reports"
      when "technicalexchange" then "Technical Exchange"
    end
  end

  def type
    case @stage
      when "tutorials" then "Tutorial"
      when "researchpapers" then "Research Paper"
      when "experiencereports" then "Experience Report"
      when "technicalexchange" then "Talk"
    end
  end

end
