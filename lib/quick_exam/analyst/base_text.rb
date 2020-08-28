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
        open_file!
        data_standardize
        protect_instance_variable
        self
      rescue => e
        raise ErrorAnalyze.new('Data can not analyze')
      end

      private

      attr_reader :object, :line
      include QuickExam::Analyst::Common

      def open_file!
        @file = File.open(@file_path, 'r')
      end

      def data_standardize
        @object = QuickExam::Record.new()

        @file.each_line.with_index do |line, num_row|
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
    end
  end
end
