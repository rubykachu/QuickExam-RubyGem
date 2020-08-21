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
        protect_instance_variable
      end

      private

      attr_reader :records, :object_qna, :dest, :tool

      def check_path(dest_path, file_path)
        if dest_path.__blank?
          @dest = File.dirname(file_path) + '/'
        else
          @dest = dest_path
        end

        return raise ErrorAnalyze.new('No such file') unless File.exist?(file_path)
        raise ErrorExport.new('No such directory') unless Dir.exist? dest
      end

      def process_export_files
        records.each_with_index do |object_qna, i|
          @object_qna = object_qna
          index_order = i + 1
          export_question_sheet(index_order)
          export_answer_sheet(index_order)
        end
      end

      def export_question_sheet(index_order)
        File.open(path_filename(index_order), 'w') do |f|
          object_qna.each_with_index do |ticket, i|
            f.write question(ticket.question, i + 1)
            f.write answers(ticket.answers)
            f.write("\n")
          end
        end
      end

      def export_answer_sheet(index_order)
        File.open(path_filename(index_order, extra_name: '_answers'), 'w') do |f|
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

      def protect_instance_variable
        remove_instance_variable(:@records)
        remove_instance_variable(:@object_qna)
        remove_instance_variable(:@dest)
        remove_instance_variable(:@tool)
        remove_instance_variable(:@alphabets)
      end
    end
  end
end
