
require 'quick_exam/analyst/base_text'

module QuickExam
  class ErrorAnalyze < StandardError; end

  class Analyzer
    attr_reader :records, :total_line, :file, :f_ques, :f_corr

    def initialize(file_path, f_ques:'' , f_corr:'')
      raise ErrorAnalyze.new('No such file') unless File.exist? file_path
      @file_path = file_path
      @f_ques = f_ques
      @f_corr = f_corr
    end

    def analyze
      return process_base_text if txt?
    ensure
      protect_instance_variable
    end

    private

    def process_base_text
      text_analyzer = QuickExam::Analyst::BaseText.new(@file_path, f_ques: @f_ques, f_corr: @f_corr)
      text_analyzer.analyze
      @records = text_analyzer.records
      @total_line = text_analyzer.total_line
      @file = text_analyzer.file
      self
    end

    def txt?
      File.extname(@file_path) == '.txt'
    end

    def protect_instance_variable
      remove_instance_variable(:@file_path)
    end
  end
end
