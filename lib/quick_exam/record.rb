module QuickExam
  class Record < Hash
    attr_accessor :question, :answers, :correct_index

    def initialize(question: '', answers: [], correct_index: [])
      @question = question
      @answers = answers
      @correct_index = correct_index
    end
  end
end
