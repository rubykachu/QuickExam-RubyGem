require 'quick_exam/format'
require 'quick_exam/record'
require 'quick_exam/record_collection'
require 'quick_exam/analyst/common'

module QuickExam
  module Analyst
    class BaseText
      include QuickExam::Format
      attr_reader :records, :total_line

      def initialize(file_path, f_ques:'' , f_corr:'')
        raise ErrorAnalyze.new('No such file') unless File.exist? file_path
        @file_path = file_path
        @f_ques = f_ques
        @f_corr = f_corr
        @records = QuickExam::RecordCollection.new()
      end

      def analyze
        data_standardize
        self
      rescue => e
        raise ErrorAnalyze.new('Data can not analyze')
      end

      private

      include QuickExam::Analyst::Common

      def data_standardize
        file = File.open(@file_path, 'r')
        @total_line = File.foreach(file).count
        @object = QuickExam::Record.new()

        file.each_line.with_index do |row, idx|
          idx += 1 # The first row is 1

          if end_of_line?(idx) || end_of_one_ticket_for_next_question?(row)
            get_answer(row) # if the last line is answer then will get answer
            collect_object_ticket
          end

          next if row.__blank?

          next if get_answer(row)
          next if get_question(row)
        end
        records
      end
    end
  end
end
