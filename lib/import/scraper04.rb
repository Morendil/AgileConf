require 'mechanize'

class Scraper04

  def initialize stage
    @stage = stage
    @agent = Mechanize.new
    @page = @agent.get "http://agile2004.agilealliance.org/schedule/#{stage}.html"
  end

  def [] symbol
    self.send symbol
  end

  def shift
    items.shift
    items.first
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

  def fetch_items
    xpath = "/html/body/table/tr[3]/td[2]/table[2]/tr/td/table/tr/td/table/tr/td[position()<=2]/a/@href"
    @page./(xpath).map(&:text).map {|each| each[1..-1]}
  end

  def title
    @page.at("a[@href='##{marker}']/text()").text
  end

  def records
    col = @page.at("a[@href='##{marker}']").parent.next_element.next_element
    return [] unless col
    links = col./("a/@href").map(&:text)
    links.map {|each| each.gsub("..","http://agile2004.agilealliance.org")}
  end

  def speakers
    names = @page.at("a[@href='##{marker}']").parent.next_element.text
    names = names.split(/(?: &amp; )|(?:(?:, ?)?and)|(?:,)/).map(&:strip)
    
  end

  def stage
    case @stage
      when "tutorials" then "Tutorials"
      when "peertopeer" then "Peer to Peer"
      when "researchp" then "Research"
      else
        stagemark = marker.split("-").first
        @page.at("a[@name='#{stagemark}']").parent.at("text()").text
    end
  end

  def type
    case @stage
      when "tutorials" then "Tutorial"
      when "researchp" then "Research Paper"
      when "expreports" then "Experience Report"
      when "peertopeer" then "Workshop"
    end
  end

  def description
    case @stage
      when "tutorials" then peertopeer_description
      when "researchp" then expreports_description
      when "expreports" then expreports_description
      when "peertopeer" then peertopeer_description
    end
  end

  def peertopeer_description
    result = @page.at("a[@name='#{marker}']")./("../../../tr[3]/td[2]//text()")
    result.map(&:text).map(&:strip).join("\n").strip
  end

  def expreports_description
    result = []
    p = @page.at("a[@name='#{marker}']").parent.next_element
    begin
      result << p.text.strip
      p = p.next_element
    end while (p.name == "p") and !p.at("a")
    result.join("\n")
  end

end

