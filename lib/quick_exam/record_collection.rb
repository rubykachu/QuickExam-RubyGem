module QuickExam
  class RecordCollection < Array
    attr_reader :records

    def initialize(records = [])
      @records = records
    end

    def mixes(count, shuffle_question: true, shuffle_answer: false)
      @records = self
      return records if count.zero?
      count.times.each_with_object([]) do |_, memo|
        new_records = records.dup
        new_records.shuffle! if shuffle_question
        shuffle_answers(new_records) if shuffle_answer
        memo << new_records
      end
    end

    private

    def shuffle_answers(array_records)
      array_records.each{ |obj| obj.shuffle_answers }
    end
  end
end
