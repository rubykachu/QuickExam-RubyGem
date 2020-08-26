require 'fileutils'
require 'quick_exam/format'

module QuickExam
  class Export
    class << self
      include QuickExam::Format
      RUN_ARGS = %w(shuffle_question shuffle_answer same_answer count dest f_ques f_corr)

      def run(file_path, options={})
        arg = validate_arguments!(options)
        count = arg[:count].__presence || 2

        check_path(arg[:dest], file_path)
        proccess_analyze(file_path, arg)
        @f_ques = question_mark(arg[:f_ques])
        @records = mixes(count, arg)
        process_export_files
      end

      private

      attr_reader :records, :object_qna, :dest, :analyzer

      def proccess_analyze(file_path, arg)
        @analyzer = QuickExam::Analyzer.new(file_path, f_ques: arg[:f_ques] , f_corr: arg[:f_corr])
        analyzer.analyze
      end

      def mixes(count, arg)
        analyzer.records.mixes(
          count,
          shuffle_question: arg[:shuffle_question],
          shuffle_answer: arg[:shuffle_answer],
          same_answer: arg[:same_answer]
        )
      end

      def check_path(dest_path, file_path)
        if dest_path.__blank?
          @dest = File.dirname(file_path) + "/#{FOLDER_NAME_EXPORT}/"
        else
          @dest = dest_path + "/#{FOLDER_NAME_EXPORT}/"
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
            f.write "#{@f_ques}#{i + 1}. #{ans}"
            f.write("\n")
          end
        end
      end

      def path_filename(index_order, extra_name: '')
        basename = File.basename(analyzer.file.path, '.*')
        basename = ("#{basename}_%.3i" % index_order) + extra_name
        extname = File.extname(analyzer.file.path)
        "#{dest}#{basename}#{extname}"
      end

      def question(str, index)
        "#{@f_ques}#{index}. #{str}\n"
      end

      def answers(data)
        str_answer = ''
        data.each_with_index { |str, i| str_answer += "#{alphabets[i]}. #{str}\n" }
        str_answer
      end

      def alphabets
        @alphabets ||= ('A'..'Z').to_a
      end

      def validate_arguments!(args)
        invalid_arg = args.detect{ |arg, _| !RUN_ARGS.include?(arg.to_s) }
        raise ArgumentError.new("unknow keyword #{invalid_arg[0]}") if invalid_arg.__present?
        RUN_ARGS.each_with_object({}) do |arg, memo|
          arg = arg.to_sym
          memo[arg] = args[arg]
        end
      end
    end
  end
end
