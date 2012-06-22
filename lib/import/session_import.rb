class Session
  def self.from hash
    speakers = (hash.delete :speakers) || []
    records = (hash.delete :records) || []
    result = Session.new hash
    speakers.each do |speaker|
      adding = (Speaker.from speaker)
      result.speakers << adding unless result.speakers.include? adding
    end
    records.each do |record|
      result.records << (Record.from record)
    end
    result
  end
end