# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'facebokr/version'

Gem::Specification.new do |gem|
  gem.name          = "facebokr"
  gem.version       = Facebokr::VERSION
  gem.authors       = ["Vladimir Yarotsky"]
  gem.email         = ["vladimir.yarotsky@gmail.com"]
  gem.summary       = %q{Facebook developer command-line tools}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency("minitest")
end
