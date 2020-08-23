require 'quick_exam/const'
require 'quick_exam/record'
require 'quick_exam/record_collection'

module QuickExam
  class ErrorAnalyze < StandardError; end

  class Analyzer
    include QuickExam::Const
    attr_reader :records, :total_line, :file

    def initialize(file_path)
      raise ErrorAnalyze.new('No such file') unless File.exist? file_path
      @file_path = file_path
      @records = QuickExam::RecordCollection.new()
    end

    def self.run(file_path)
      tool = QuickExam::Analyzer.new(file_path)
      tool.analyze
      tool
    rescue => e
      raise ErrorAnalyze.new('Data can not analyze')
    end

    def analyze
      raise IOError.new 'File does not exist or is unreadable' unless File.exists? file_path
      open_file!
      data_standardize
      protect_instance_variable
      records
    rescue => e
      raise ErrorAnalyze.new('Data can not analyze')
    end

    private

    attr_reader :file_path, :object, :line

    def open_file!
      @file = File.open(file_path, 'r')
    end

    def data_standardize
      @object = QuickExam::Record.new()

      file.each_line.with_index do |line, num_row|
        num_row += 1 # The first row is 1
        @line = line

        if end_of_line?(num_row) || end_of_one_ticket_for_next_question?
          get_answer # if the last line is answer then will get answer
          collect_object_ticket
        end

        next if line.__blank?

        next if get_answer
        next if get_question
      end
      records
    end

    def get_question
      return if object.answers.__present?
      object.question += question(line)
    end

    def get_answer
      return if object.question.__blank?
      return unless answer?(line)
      # unless answer?(line) || question?(line)
      #   return if object.answers.__blank?
      #   last_index = object.answers.size - 1
      #   object.answers[last_index] = "#{object.answers.last} #{line}"
      #   return
      # end

      # Get answer
      object.answers << answer(line)
      get_correct_indexes_answer
    end

    def get_correct_indexes_answer
      return unless correct_answer?(line)
      object.correct_indexes << object.answers.size - 1
    end

    def end_of_one_ticket_for_next_question?
      object.answers.__present? && object.question.__present? && question?(line)
    end

    def collect_object_ticket
      records << clean_object
      reset_object_ticket
    end

    def clean_object
      object.question.strip!
      object.answers.map(&:strip!)
      object
    end

    def reset_object_ticket
      @object = QuickExam::Record.new()
    end

    # TODO: Regex question
    # Format question: Q1: , Q2: , Q3:
    # i: case insensitive
    # m: make dot match newlines
    # x: ignore whitespace in regex
    # ?<= : positive lookbehind
    def question?(str)
      str = rid_non_ascii!(str)
      str[(/(#{QUESTION_MARK}\d+:).+\S/ixm)].__present?
    end

    # TODO: Regex answer
    # Format answer: A. , B. , C. , D.
    # i: case insensitive
    # x: ignore whitespace in regex
    # ?<= : positive lookbehind
    def answer?(str)
      str = rid_non_ascii!(str)
      !str[(/(?<=^\w\.).*/ix)].to_s.empty?
    end

    # TODO: Regex get clean answer
    # i: case insensitive
    # ?<= : positive lookbehind
    # ?= : positive lookahead
    def answer(str)
      ans_with_mark_correct = /((?<=^\w\.).*(?=!!!Correct))/
      ans_without_mark_correct = /(?<=^\w\.).*/
      str[(/#{ans_with_mark_correct}|#{ans_without_mark_correct}/ix)].__presence || str
    end

    # TODO: Regex get clean question
    # i: case insensitive
    # m: make dot match newlines
    # ?<= : positive lookbehind
    def question(str)
      letter_question = str.match(/(^#{QUESTION_MARK}\d+:).+\S/im).to_a.last
      str[(/(?<=#{letter_question}).+/im)].__presence || str
    end

    def correct_answer?(str)
      str.downcase.include?(CORRECT_MARK.downcase)
    end

    def end_of_line?(num_row)
      @total_line ||= `wc -l "#{file.path}"`.strip.split(' ')[0].to_i
      num_row == total_line
    end

    # TODO: Remove non-unicode character
    # Solutions:
    #   Ref: https://stackoverflow.com/a/26411802/14126700
    #   Ref: https://www.regular-expressions.info/posixbrackets.html
    #   [:print:] : Visible characters and spaces (anything except control characters)
    def rid_non_ascii!(str)
      # Solution 1: str.chars.reject { |char| char.ascii_only? and (char.ord < 32 or char.ord == 127) }.join
      non_utf8 = str.slice(str[/[^[:print:]]/])
      return str if non_utf8 == "\n" || non_utf8 == "\t"
      str.slice!(str[/[^[:print:]]/])
      str
    end

    def protect_instance_variable
      remove_instance_variable(:@object)
      remove_instance_variable(:@line)
      remove_instance_variable(:@file_path)
    end
  end
end
