
require 'quick_exam/analyst/base_text'
require 'quick_exam/analyst/base_html'

module QuickExam
  class Analyzer
    attr_reader :records, :total_line, :f_ques, :f_corr

    def initialize(file_path, f_ques:'' , f_corr:'')
      raise ErrorAnalyze.new('No such file') unless File.exist? file_path
      @file_path = file_path
      @f_ques = f_ques
      @f_corr = f_corr
    end

    def analyze
      case
      when txt? then process_base_text
      when html? then process_base_html
      end
    ensure
      protect_instance_variable
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
    end

    def txt?
      File.extname(@file_path) == '.txt'
    end

    def html?
      File.extname(@file_path) == '.html'
    end

    def protect_instance_variable
      remove_instance_variable(:@file_path)
    rescue
      nil
    end
  end
end
