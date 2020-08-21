require 'fileutils'
require 'quick_exam/const'

module QuickExam
  class ErrorExport < StandardError; end

  class Export
    class << self
      include QuickExam::Const

      def run(file_path, shuffle_question: true, shuffle_answer: false, count: 2, dest: '')
        check_path(dest, file_path)

        @tool = QuickExam::Analyzer.run(file_path)
        @records = tool.records.mixes(count, shuffle_question: shuffle_question, shuffle_answer: shuffle_answer)
        process_export_files
      end

      private

      attr_reader :records, :object_qna, :dest, :tool

      def check_path(dest_path, file_path)
        if dest_path.__blank?
          @dest = File.dirname(file_path) + '/quick_exam_export/'
        else
          @dest = dest_path + '/quick_exam_export/'
        end

        return raise ErrorExport.new('No such file') unless File.exist?(file_path)
        FileUtils.mkdir_p(dest) unless Dir.exist? dest
      end

      def process_export_files
        path_dest_files = []
        records.each_with_index do |object_qna, i|
          @object_qna = object_qna
          i = i + 1
          file_path_question = path_filename(i)
          file_path_answer = path_filename(i, extra_name: '_answers')
          export_question_sheet(file_path_question)
          export_answer_sheet(file_path_answer)
          path_dest_files << file_path_question << file_path_answer
        end
        path_dest_files
      end

      def export_question_sheet(path_filename)
        File.open(path_filename, 'w') do |f|
          object_qna.each_with_index do |ticket, i|
            f.write question(ticket.question, i + 1)
            f.write answers(ticket.answers)
            f.write("\n")
          end
        end
      end

      def export_answer_sheet(path_filename)
        File.open(path_filename, 'w') do |f|
          object_qna.each_with_index do |ticket, i|
            ans = ticket.correct_indexes.map { |ci| alphabets[ci] }.join(', ')
            f.write "#{QUESTION_MARK}#{i + 1}. #{ans}"
            f.write("\n")
          end
        end
      end

      def path_filename(index_order, extra_name: '')
        basename = File.basename(tool.file.path, '.*')
        basename = ("#{basename}_%.3i" % index_order) + extra_name
        extname = File.extname(tool.file.path)
        "#{dest}#{basename}#{extname}"
      end

      def question(str, index)
        "#{QUESTION_MARK}#{index}. #{str}\n"
      end

      def answers(data)
        str_answer = ''
        data.each_with_index { |str, i| str_answer += "#{alphabets[i]}. #{str}\n" }
        str_answer
      end

      def alphabets
        @alphabets ||= ('A'..'Z').to_a
      end
    end
  end
end
