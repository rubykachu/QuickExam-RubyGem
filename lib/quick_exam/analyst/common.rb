module QuickExam
  module Analyst
    module Common
      def get_question(str)
        return if @object.answers.__present?
        @object.question += question(str)
      end

      def get_answer(str)
        return if @object.question.__blank?
        return unless answer?(str)

        # Get answer
        @object.answers << answer(str)
        get_correct_indexes_answer(str)
      end

      def get_correct_indexes_answer(str)
        return unless correct_answer?(str)
        @object.correct_indexes << @object.answers.size - 1
      end

      def end_of_one_ticket_for_next_question?(str)
        str = Sanitize.fragment(str)
        @object.answers.__present? && @object.question.__present? && question?(str)
      end

      def end_of_line?(num_row)
        num_row == @total_line
      end

      def collect_object_ticket
        @records << clean_object
        reset_object_ticket
      end

      def clean_object
        @object.question.strip!
        @object.answers.map(&:strip!)
        @object
      end

      def reset_object_ticket
        @object = QuickExam::Record.new()
      end

      def correct_answer?(str)
        str.downcase.include?(correct_mark(@f_corr).downcase)
      end

      def question?(str)
        str = rid_non_ascii!(str)
        str = Sanitize.fragment(str).__squish
        str[(regex_question_mark)].__present?
      end

      def answer?(str)
        str = rid_non_ascii!(str)
        str = Sanitize.fragment(str).__squish
        str[(regex_answer_mark)].__present?
      end

      # TODO: Regex get clean answer
      # i: case insensitive
      # x: ignore whitespace in regex
      # ?= : positive lookahead
      def answer(str)
        corr_mark = correct_mark(@f_corr, safe: true)
        ans_with_mark_correct = /(#{regex_answer_sentence}(?=#{corr_mark}))/
        ans_without_mark_correct = regex_answer_sentence
        str[(/#{ans_with_mark_correct}|#{regex_answer_sentence}/ix)].__presence || str
      end

      # TODO: Regex get clean question
      # i: case insensitive
      # m: make dot match newlines
      # ?<= : positive lookbehind
      def question(str)
        letter_question = Regexp.quote(str.match(regex_question_mark).to_a.last.to_s)
        str[(/(?<=#{letter_question}).+/im)].__presence || str
      end

      # TODO: Regex match question mark
      # Format question: Q1: , q1. , q1) , Q1/
      # @return: Question mark
      #
      # i: case insensitive
      # m: make dot match newlines
      # x: ignore whitespace in regex
      def regex_question_mark
        ques_mark = question_mark(@f_ques, safe: true)
        /(^#{ques_mark}[\s]*\d+[:|\)|\.|\/])/ixm
      end

      # TODO: Regex match answer sentence
      # Format question: A) , a. , 1/
      # @return: Answer sentence without answer mark
      #
      # ?<= : positive lookbehind
      def regex_answer_sentence
        /(?<=#{regex_answer_mark}).*/
      end

      # TODO: Regex match answer mark
      # Format question: A) , a. , 1/
      # @return: Answer mark
      def regex_answer_mark
        /(^\w[\.|\)|\/])/
      end

      # TODO: Remove non-unicode character
      # Solutions:
      #   Ref: https://stackoverflow.com/a/26411802/14126700
      #   Ref: https://www.regular-expressions.info/posixbrackets.html
      #   [:print:] : Visible characters and spaces (anything except control characters)
      def rid_non_ascii!(str)
        # Solution 1: str.chars.reject { |char| char.ascii_only? and (char.ord < 32 or char.ord == 127) }.join
        non_utf8 = str.slice(str[/[^[:print:]]/].to_s)
        return str if non_utf8 == "\n" || non_utf8 == "\t"
        str.slice!(str[/[^[:print:]]/].to_s)
        str
      end
    end
  end
end
