require 'quick_exam/format'
require 'quick_exam/record'
require 'quick_exam/record_collection'

module QuickExam
  class Analyst::BaseHTML
    include QuickExam::Format
    attr_reader :records, :total_line, :file

    def initialize(file_path, f_ques: '' , f_corr: '')
      raise ErrorAnalyze.new('No such file') unless File.exist? file_path
      @file_path = file_path
      @f_ques = f_ques
      @f_corr = f_corr
      @records = QuickExam::RecordCollection.new()
    end

    def analyze
      data_standardize
    end

    private

    include QuickExam::Analyst::Common

    def data_standardize
      @object = QuickExam::Record.new()

      doc = File.open(@file_path) { |f| Nokogiri::HTML(f) }
      data = doc.search('.WordSection1 .MsoNormal')
      @total_line = data.size
      data.each_with_index do |element, idx|
        content_html = Sanitize.fragment(element, elements: ALLOWED_ELEMENTS).gsub(regex_ele_empty, '').__squish
        idx += 1 # The first row is 1

        if end_of_line?(idx) || end_of_one_ticket_for_next_question?(content_html)
          get_answer_html(content_html) # if the last line is answer then will get answer
          collect_object_ticket
        end

        next if element_empty? Sanitize.fragment(element)
        next if get_answer_html(content_html)
        next if get_question_html(content_html)
      end
    end

    def get_answer_html(str)
      return unless answer?(str)
      ans = str.split(answer_mark_html(str)).last
      return if ans.__blank?

      ans = Nokogiri::HTML(ans).to_html
      ans = Sanitize.fragment(ans, elements: ALLOWED_ELEMENTS)
      ans = ans.split(@f_corr)[0].__squish

      @object.answers << ans
      get_correct_indexes_answer(str)
    end

    def get_question_html(str)
      return if @object.answers.__present?
      # Split question from question_mark and Get question
      ques = str.split(question_mark_html(str)).last

      # Chain question if not question and not answer
      return @object.question += str if ques.__blank? && !answer?(str)

      # fix unclosed HTML tags
      ques = Nokogiri::HTML(ques).to_html
      @object.question += Sanitize.fragment(ques, elements: ALLOWED_ELEMENTS).__squish
    end

    def question_mark_html(str)
      dirty_f_ques = ''
      str.chars.detect do |char|
        dirty_f_ques += char
        question?(dirty_f_ques)
      end

      # fix unclosed HTML tags
      dirty_f_ques = Nokogiri::HTML(dirty_f_ques).to_html
      Sanitize.fragment(dirty_f_ques, elements: ALLOWED_ELEMENTS).__squish
    end

    def answer_mark_html(str)
      dirty_f_ans = ''
      str.chars.detect do |char|
        dirty_f_ans += char
        answer?(dirty_f_ans)
      end

      # fix unclosed HTML tags
      dirty_f_ans = Nokogiri::HTML(dirty_f_ans).to_html
      Sanitize.fragment(dirty_f_ans, elements: ALLOWED_ELEMENTS).__squish
    end

    def element_empty?(str)
      str.__squish.__blank? || (str =~ regex_ele_empty).__present?
    end

    def regex_ele_empty
      /<[^\/>][^>]*>[\s]*<\/[^>]+>/
    end
  end
end
