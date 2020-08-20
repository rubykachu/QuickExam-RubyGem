require "quick_exam/version"
require "quick_exam/core_ext"
require "quick_exam/analyzer"

# Sample data
# [
#   {
#     question: '',
#     answers: ['', '', '', '', '', '', '', ''],
#     correct_index: [1, 2, 3]
#   }, ...
# ]

module QuickExam
  class Error < StandardError; end

  class << self
    CORRECT_MARK = '!!!Correct'
    QUESTION_MARK = 'Q'

    def get_data
      data     = []
      object   = { question: '', answers: [], correct_index: [] }

      @file = File.open(__dir__ + '/exam.txt', 'r')

      file.each_line.with_index do |line, num_row|
        num_row += 1 # The first row start is 1

        next if line == "\n" || line == ""

        # Get data for FIRST question
        if object[:answers].empty? && question?(line)
          object[:question] += line
          next
        end

        # Process get data for NEXT question
        if !object[:answers].empty? && question?(line)
          data << object
          # Reset data for next question
          object = { question: '', answers: [], correct_index: [] }

          # Get data for next question
          object[:question] += line
          next
        end

        # Process get data for LAST question
        data << object if end_of_line?(num_row)

        # Process chain question and get answers
        if !object[:question].empty?
          if answer?(line)
            # Get answer
            object[:answers] << split_answer_from_mark_correct(line)

            # Get index correct
            object[:correct_index] << object[:answers].size - 1 if correct_answer?(line)
          else
            # Chain question
            object[:question] += line
          end
        end
      end
      file.close
      data
    end

    # TODO: Regex question
    # Format question: Q1: , Q2: , Q3:
    # i: case insensitive
    # m: make dot match newlines
    # x: ignore whitespace in regex
    # ?<= : positive lookbehind
    def question?(str)
      str = rid_non_ascii!(str)
      !str[(/(?<=#{QUESTION_MARK}.:).*/ixm)].to_s.empty?
    end

    # TODO: Regex same a question
    # Format answer: A. , B. , C. , D.
    def answer?(str)
      str = rid_non_ascii!(str)
      !str[(/(?<=^\w\.).*/ix)].to_s.empty?
    end

    # ?= : positive lookahead
    def split_answer_from_mark_correct(str)
      str[(/^(\w).*(?=#{CORRECT_MARK})/i)].strip
    rescue
      str
    end

    def correct_answer?(str)
      str.downcase.include?(CORRECT_MARK.downcase)
    end

    def end_of_line?(num_row)
      @total_line ||= `wc -l "#{file.path}"`.strip.split(' ')[0].to_i
      num_row == @total_line
    end

    # Ref: https://stackoverflow.com/a/26411802/14126700
    # Ref: https://www.regular-expressions.info/posixbrackets.html
    # [:print:] : Visible characters and spaces (anything except control characters)
    def rid_non_ascii!(str)
      # str.chars.reject { |char| char.ascii_only? and (char.ord < 32 or char.ord == 127) }.join
      non_utf8 = str.slice(str[/[^[:print:]]/])
      return str if non_utf8 == "\n" || non_utf8 == "\t"
      str.slice!(str[/[^[:print:]]/])
      str
    end

    def file
      @file
    end
  end
end

QuickExam.get_data
