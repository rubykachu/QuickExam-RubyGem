module QuickExam
  class Record
    attr_accessor :question, :answers, :correct_indexes

    def initialize(question: '', answers: [], correct_indexes: [])
      @question = question
      @answers = answers
      @correct_indexes = correct_indexes
    end

    def answers_with_hash
      answers.map.with_index.to_h.invert
    end

    def shuffle_answers
      ans = answers_with_hash.sort{|a, b| rand(40) <=> rand(40) }.to_h
      self.answers = ans.values
      self.correct_indexes = specific_index_correct_answer(ans)
    end

    private

    def specific_index_correct_answer(data_hash)
      correct_indexes.each_with_object([]) do |i, indexes|
        indexes << data_hash.find_index { |key, _| key == i }
      end.sort
    end
  end
end
