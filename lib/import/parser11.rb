require 'csv'

class Parser11

  def initialize csv
    @csv = CSV.open(csv,:headers=>true)
    @row = @csv.shift
  end

  def [] symbol
    case symbol
      when :speakers then speakers
      when :type then @row["session_type"]
    else @row[symbol.to_s]
    end
  end

  def speakers
   result = []
   result << @row["presenter1"] unless @row["presenter1"] == ""
   result << @row["presenter2"] unless @row["presenter2"] == ""
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

