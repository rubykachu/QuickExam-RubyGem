# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'quick_exam/version'

Gem::Specification.new do |spec|
  spec.name          = "quick_exam"
  spec.version       = QuickExam::VERSION
  spec.author        = "tm-minhtang"
  spec.email         = "minh.tang@tomosia.com"

  spec.summary       = "Shuffle quickly questions and answers"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/tm-minhtang/quick_exam.git"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org/"
  spec.metadata["homepage_uri"]      = spec.homepage
  spec.metadata["source_code_uri"]   = "https://github.com/tm-minhtang/quick_exam/tree/master"
  spec.metadata["changelog_uri"]     = "https://github.com/tm-minhtang/quick_exam/tree/master/CHANGELOG.md"
  spec.metadata["documentation_uri"] = "https://github.com/tm-minhtang/quick_exam/tree/master/README.md"
  spec.metadata["bug_tracker_uri"]   = "https://github.com/tm-minhtang/quick_exam/issues"

  # Specify which files should be added to the gem when it is released.
  except_files = %w(Rakefile quick_sample.txt).join(' ')
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end.reject!{ |f| except_files.include?(f) }

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 2.1', '>= 2.1.4'
  spec.add_development_dependency 'pry',     '~> 0.13.1'
  spec.add_development_dependency 'rake',    '~> 12.0'
end
