require_relative 'lib/quick_exam/version'

Gem::Specification.new do |spec|
  spec.name          = "quick_exam"
  spec.version       = QuickExam::VERSION
  spec.authors       = ["tm-minhtang"]
  spec.email         = ["minh.tang@tomosia.com"]

  spec.summary       = "Shuffle quickly questions and answers"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/tm-minhtang/quick_exam.git"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org/"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/tm-minhtang/quick_exam/tree/master"
  spec.metadata["changelog_uri"] = "https://github.com/tm-minhtang/quick_exam/tree/master/CODE_OF_CONDUCT.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
