require 'mechanize'

class Scraper03

  def initialize link
    @agent = Mechanize.new
    @page = @agent.get link
  end

  def items
    xpath = "/html/body/table/tr[3]/td[2]/table[2]/tr/td/table[1]/tr/td/table/tr/td[1]"
    @page./(xpath).map(&:text)[1..-1]
  end

end

