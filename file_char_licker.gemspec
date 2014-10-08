# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'file_char_licker/version'

Gem::Specification.new do |spec|
  spec.name          = "file_char_licker"
  spec.version       = FileCharLicker::VERSION
  spec.authors       = ["indeep-xyz"]
  spec.email         = ["indeep.xyz@gmail.com"]
  spec.summary       = %q{move the position of file pointer in character-based and get string and.}
  spec.description   = <<EOT
it has the following functions.

- move the position of file pointer in character-based.
- get string that is around the file pointer.
- support for multi-byte character.
EOT
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
