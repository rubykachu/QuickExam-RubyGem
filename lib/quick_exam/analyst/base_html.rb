require 'nokogiri'
require 'sanitize'
require 'quick_exam/format'
require 'quick_exam/record'
require 'quick_exam/record_collection'

module QuickExam
  class Analyst::BaseHTML
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
      data_standardize
    end

    private

    attr_reader :file_path, :object, :line
    include QuickExam::Analyst::Common

    def data_standardize
      doc = File.open(@file_path) { |f| Nokogiri::HTML(f) }
      doc.search('.WordSection1 .MsoNormal').each_with_index do |element, idx|
        html_string = Sanitize.fragment(element, elements: ALLOWED_ELEMENTS)
        text = Sanitize.fragment(element).strip
        binding.pry
      end
    end
  end
end
