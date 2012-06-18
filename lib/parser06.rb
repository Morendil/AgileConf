require 'csv'

class Parser06

  def initialize csv
    @csv = CSV.open(csv,:headers=>true)
    @row = @csv.shift
  end

  def [] symbol
    case symbol
      when :speakers then speakers
      when :records then records
      when :title then @row["Title"]
      when :description then @row["Abstract"]
      when :type then type @row["Type"]
      when :stage then stage @row["Type"]
    else @row[symbol.to_s]
    end
  end

  def type code
    case code
      when "AS" then "Experience Report"
      when "XR" then "Experience Report"
      when "BT" then "Tutorial"
      when "TU" then "Tutorial"
      when "DS" then "Workshop"
      when "HO" then "Workshop"
      when "ES" then "Research Paper"
      when "RP" then "Research Paper"
      else "Talk"
    end
  end

  def stage code
    case code
      when "AS" then "Agile Stories"
      when "XR" then "Experience Reports"
      when "BT" then "Beginners"
      when "TU" then "Tutorials"
      when "DS" then "Discovery Sessions"
      when "HO" then "Hands-on"
      when "ES" then "Educator's Symposium"
      when "RP" then "Research"
      else "Main"
    end
  end

  def speakers
   result = []
   result << @row["First1"]+" "+@row["Last1"] unless @row["Last1"] == ""
   result << @row["First2"]+" "+@row["Last2"] unless @row["Last2"] == ""
   result
  end

  def all_records
    @all_records || @all_records = File.readlines("data/Agile2006-files.txt")
  end

  def records
    id = @row["NewID"]
    result = all_records.select {|each| each.start_with? "#{id} "}
    result.map &:strip
  end

  def hash
    result = {}
    [:id,:title,:description,:type,:speakers,:records,:stage].each do |key|
      result[key]=self[key]
    end
    result
  end

  def shift
    @row = @csv.shift
  end

end

