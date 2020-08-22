# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'quick_exam/version'

year = Time.now.year.to_s == '2020' ? '2020' : "2020 - #{Time.now.year}"
Gem::Specification.new do |spec|
  spec.name          = "quick_exam"
  spec.version       = QuickExam::VERSION
  spec.author        = 'Tang Quoc Minh'
  spec.email         = 'vhquocminhit@gmail.com'

  spec.summary       = 'You can shuffle or randomize quiz questions and answers.'
  spec.description   = 'You can shuffle or randomize quiz questions and answers. Shuffling is also an effective way of preventing cheating because no two learners get questions in the same order while taking the same quiz.'
  spec.homepage      = 'https://github.com/tm-minhtang/quick_exam.git'
  spec.license       = 'MIT'
  spec.post_install_message = <<EOF
Thanks for installing
Gem quick_exam #{QuickExam::VERSION} (latest) (c) #{year} Tang Quoc Minh [vhquocminhit@gmail.com]
EOF

  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.metadata["allowed_push_host"] = 'https://rubygems.org/'
  spec.metadata['homepage_uri']      = spec.homepage
  spec.metadata['source_code_uri']   = 'https://github.com/tm-minhtang/quick_exam/tree/master'
  spec.metadata['changelog_uri']     = 'https://github.com/tm-minhtang/quick_exam/tree/master/CHANGELOG.md'
  spec.metadata['documentation_uri'] = 'https://github.com/tm-minhtang/quick_exam/tree/master/README.md'
  spec.metadata['bug_tracker_uri']   = 'https://github.com/tm-minhtang/quick_exam/issues'

  # Specify which files should be added to the gem when it is released.
  except_files = %w(Rakefile quick_sample.txt).join(' ')
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end.reject!{ |f| except_files.include?(f) }

  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'thor'
  spec.add_development_dependency 'bundler', '~> 2.1', '>= 2.1.4'
end
