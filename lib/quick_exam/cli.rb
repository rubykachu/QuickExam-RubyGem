require 'thor'
require 'pry'
require 'quick_exam'

module QuickExam
  class CLI < Thor
    desc 'help export', 'Help'
    def self.help(shell, subcommand = false)
      list = printable_commands(true, subcommand)
      Thor::Util.thor_classes_in(self).each do |klass|
        list += klass.printable_commands(false)
      end

      # Remove this line to disable alphabetical sorting
      list.sort! { |a, b| a[0] <=> b[0] }

      # Add this line to remove the help-command itself from the output
      # list.reject! {|l| l[0].split[1] == 'help'}
      if defined?(@package_name) && @package_name
        shell.say "#{@package_name} commands:"
      else
        shell.say "Commands:"
      end

      shell.print_table(list, :indent => 2, :truncate => true)
      shell.say
      class_options_help(shell)

      # Add this line if you want to print custom text at the end of your help output.
      # (similar to how Rails does it)
      shell.say 'All commands can be run with -h (or --help) for more information.'
    end

    def self.define_exec_options
      option :shuffle_question, type: :string,  aliases: ['-q'],  default: 'true',  desc: 'Shuffle the question',                      banner: 'true|false'
      option :shuffle_answer,   type: :string,  aliases: ['-a'],  default: 'false', desc: 'Shuffle the answer',                        banner: 'true|false'
      option :same_answer,      type: :string,  aliases: ['-s'],  default: 'false', desc: 'The same answer for all questionnaires',    banner: 'false'
      option :f_ques,           type: :string,  aliases: ['-Q'], default: 'Q',     desc: 'Question format. Just prefix the question', banner: 'Q'
      option :f_corr,           type: :string,  aliases: ['-C'], default: '!!!T',  desc: 'Correct answer format',                     banner: '!!!T'
      option :count,            type: :string,  aliases: ['-c'],  default: '2',     desc: 'Number of copies to created',               banner: '2'
      option :dest,             type: :string,  aliases: ['-d'],  default: '',      desc: 'File storage path after export',            banner: '~/quick_exam_export/'
    end

    desc 'export FILE_PATH [options]', 'shuffle or randomize quiz questions and answers then export file'
    define_exec_options
    def export(file_path)
      shuffle_question = options[:shuffle_question] == 'true' ? true : false
      shuffle_answer   = options[:shuffle_answer] == 'true' ? true : false
      same_answer      = options[:same_answer] == 'true' ? true : false
      f_ques           = options[:f_ques]
      f_corr           = options[:f_corr]
      count            = options[:count].to_i
      dest             = options[:dest]

      paths_export = QuickExam::Export.run(
        file_path,
        shuffle_question: shuffle_question,
        shuffle_answer: shuffle_answer,
        count: count,
        dest: dest,
        f_ques: f_ques,
        f_corr: f_corr,
        same_answer: same_answer
      )
      show_msg_after_export(paths_export)
    end

    map %w[--version -v] => :__print_version
    desc '--version, -v', 'Show `quick_exam` version'
    def __print_version
      year = Time.now.year.to_s == '2020' ? '2020' : "2020 - #{Time.now.year}"
      puts "quick_exam #{QuickExam::VERSION} (latest) (c) #{year} Tang Quoc Minh [vhquocminhit@gmail.com]"
    end

    private

    def show_msg_after_export(paths_export)
      puts '♥️ Congratulations on your successful export ♥️'
      paths_export.each { |path| puts path }
    end
  end
end
