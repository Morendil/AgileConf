require 'csv'
require 'mechanize'

class Parser08

  def initialize csv
    @csv = CSV.open(csv,:headers=>true)
    @row = @csv.shift
    @agent = Mechanize.new
  end

  def [] symbol
    case symbol
      when :speakers then speakers
      when :description then description
      when :type then @row["session_type"]
    else @row[symbol.to_s]
    end
  end

  def description
    begin
      node = @row["id"]
      page = @agent.get "http://submissions2008.agilealliance.org/node/#{node}/"
      page./("//*[@id='node-#{node}']/div[@class='content']").to_xhtml
    rescue
      "(No description)"
    end    
  end

  def empty column
    @row[column].nil? || @row[column] == ""
  end

  def speakers
   result = []
   result << @row["presenter1"] unless empty "presenter1"
   result << @row["presenter2"] unless empty "presenter2"
   result
  end

  def hash
    result = {}
    [:id,:title,:description,:type,:speakers,:stage].each do |key|
      result[key]=self[key]
    end
    result
  end

  def shift
    @row = @csv.shift
  end

end

