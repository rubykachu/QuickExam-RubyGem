require 'quick_exam/format'
require 'quick_exam/record'
require 'quick_exam/record_collection'

module QuickExam
  module Analyst
    class BaseText
      include QuickExam::Format
      attr_reader :records, :total_line, :file

      def initialize(file_path, f_ques:'' , f_corr:'')
        raise ErrorAnalyze.new('No such file') unless File.exist? file_path
        @file_path = file_path
        @f_ques = f_ques
        @f_corr = f_corr
        @records = QuickExam::RecordCollection.new()
      end

      def analyze
        open_file!
        data_standardize
        protect_instance_variable
        self
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

      def correct_answer?(str)
        str.downcase.include?(correct_mark(@f_corr).downcase)
      end

      def end_of_line?(num_row)
        @total_line ||= `wc -l "#{file.path}"`.strip.split(' ')[0].to_i
        num_row == total_line
      end

      def question?(str)
        str = rid_non_ascii!(str)
        str[(regex_match_question_mark)].__present?
      end

      def answer?(str)
        str = rid_non_ascii!(str)
        !str[(regex_match_answer_mark)].to_s.empty?
      end

      # TODO: Regex get clean answer
      # i: case insensitive
      # x: ignore whitespace in regex
      # ?= : positive lookahead
      def answer(str)
        corr_mark = correct_mark(@f_corr, safe: true)
        ans_with_mark_correct = /(#{regex_match_answer_mark}(?=#{corr_mark}))/
        ans_without_mark_correct = regex_match_answer_mark
        str[(/#{ans_with_mark_correct}|#{regex_match_answer_mark}/ix)].__presence || str
      end

      # TODO: Regex get clean question
      # i: case insensitive
      # m: make dot match newlines
      # ?<= : positive lookbehind
      def question(str)
        letter_question = Regexp.quote(str.match(regex_match_question_mark).to_a.last.to_s)
        str[(/(?<=#{letter_question}).+/im)].__presence || str
      end

      # TODO: Regex match question mark
      # Format question: Q1: , q1. , q1) , Q1/
      # @return: Question mark
      #
      # i: case insensitive
      # m: make dot match newlines
      # x: ignore whitespace in regex
      def regex_match_question_mark
        ques_mark = question_mark(@f_ques, safe: true)
        /(^#{ques_mark}[\s]*\d+[:|\)|\.|\/]).+\S/ixm
      end

      # TODO: Regex match answer mark
      # Format question: A) , a. , 1/
      # @return: Answer sentence without answer mark
      #
      # ?<= : positive lookbehind
      def regex_match_answer_mark
        /(?<=^\w[\.|\)|\/]).*/
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
        %w(@object @line @file_path).each do |v|
          remove_instance_variable(:"#{v}")
        end
      end
    end
  end
end
