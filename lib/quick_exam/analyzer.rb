require 'quick_exam/format'
require 'quick_exam/analyst/base_text'
require 'quick_exam/analyst/base_docx'
require 'quick_exam/analyst/base_html'

module QuickExam
  class Analyzer
    include QuickExam::Format
    attr_reader :records, :total_line, :f_ques, :f_corr

    def initialize(file_path, f_ques:'' , f_corr:'')
      raise ErrorAnalyze.new('No such file') unless File.exist? file_path
      @file_path = file_path
      @f_ques = f_ques.__presence || QUESTION_MARK
      @f_corr = f_corr.__presence || CORRECT_MARK
    end

    def analyze
      case
      when txt? then process_base_text
      when docx? then process_base_docx
      when html? then process_base_html
      end
    end

    private

    def process_base_text
      text_analyzer = QuickExam::Analyst::BaseText.new(@file_path, f_ques: @f_ques, f_corr: @f_corr)
      text_analyzer.analyze
      @records = text_analyzer.records
      @total_line = text_analyzer.total_line
      self
    end

    def process_base_html
      html_analyzer = QuickExam::Analyst::BaseHTML.new(@file_path, f_ques: @f_ques, f_corr: @f_corr)
      html_analyzer.analyze
      @records = html_analyzer.records
      @total_line = html_analyzer.total_line
      self
    end

    def process_base_docx
      docx_analyzer = QuickExam::Analyst::BaseDocx.new(@file_path, f_ques: @f_ques, f_corr: @f_corr)
      docx_analyzer.analyze
      @records = docx_analyzer.records
      @total_line = docx_analyzer.total_line
      self
    end

    def txt?
      File.extname(@file_path) == '.txt'
    end

    def html?
      File.extname(@file_path) == '.html'
    end

    def docx?
      File.extname(@file_path) == '.docx'
    end
  end
end
