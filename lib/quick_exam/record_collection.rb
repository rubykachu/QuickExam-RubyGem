module QuickExam
  class RecordCollection < Array
    attr_reader :records

    def initialize(records = [])
      @records = records
    end
  end
end
