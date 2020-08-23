module QuickExam
  module Format
    CORRECT_MARK = '!!!T'
    QUESTION_MARK = 'Q'
    FOLDER_NAME_EXPORT = 'quick_exam_export'

    def correct_mark(mark='', safe: false)
      return CORRECT_MARK if mark.__blank?
      return Regexp.quote(mark) if safe
      mark
    end

    def question_mark(mark='', safe: false)
      return QUESTION_MARK if mark.__blank?
      return Regexp.quote(mark) if safe
      mark
    end
  end
end
