module QuickExam
  module Format
    CORRECT_MARK = '!!!T'
    QUESTION_MARK = 'Q'
    FOLDER_NAME_EXPORT = 'quick_exam_export'
    ALLOWED_ELEMENTS = %w(a abbr b blockquote br cite code dd dfn dl dt em i kbd li mark ol pre
      q s samp small strike strong sub sup time u ul var)

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
