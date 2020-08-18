require "quick_exam/version"

module QuickExam
  class Error < StandardError; end
  def self.hello_world?
    puts 'Hello World!!!'
  end
end

QuickExam.hello_world?
