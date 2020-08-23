module QuickExam
  class RecordCollection < Array
    attr_reader :records

    def initialize(records = [])
      @records = records
    end

    def mixes(count, shuffle_question: true, shuffle_answer: false, same_answer: false)
      @records = self
      @same_answer = same_answer
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
      array_records.each_with_index do |obj,  i|
        # Todo: The same answer for all questionnaires
        # obj.dup => difference, otherwise
        n_obj = @same_answer ? obj : obj.dup

        n_obj.shuffle_answers
        array_records[i] = n_obj
      end
    end
  end
end
