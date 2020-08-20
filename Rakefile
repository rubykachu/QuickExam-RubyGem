require "bundler/gem_tasks"

namespace :gem do
  task :remove do
    `gem uninstall quick_exam`
    p 'Removed'
  end

  task :reinstall do
    `gem uninstall quick_exam` rescue nil
    `rm quick_exam-0.1.0.gem` rescue nil
    `gem build quick_exam.gemspec`
    `gem install quick_exam-0.1.0.gem`
    p 'Restarted'
  end
end

task :default => :spec
