# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'XCUtils/version'

Gem::Specification.new do |spec|
  spec.name          = "XCUtils"
  spec.version       = XCUtils::VERSION
  spec.authors       = ["Benjamin Müller", "Manolis Pahlke"]
  spec.email         = ["benjamin@urbn.de", "manolis@urbn.de"]
  spec.description   = %q{This is a little helper to resize @2x~ipad artwork to all required sizes using rmagick.
    \x5On top, the output will be formatted to suit XCodes requirements for sprite atlases or xcassets.
    \x5Images will be resized carefully using 'HammingFilter'.}
  spec.summary       = %q{Resize *.@2x~ipad named images and move em into XCodes atlases or xcassets.}
  spec.homepage      = "https://github.com/elchbenny/XCUtils"
  spec.license       = "MIT"

  spec.files         = ["lib/XCUtils/version.rb", "lib/XCUtils/xcutils_resize.rb", "lib/XCUtils/xcutils_sorter.rb"]
  spec.executables   << 'xcutils'
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "thor"
  spec.add_development_dependency "rmagick", "~> 2.13.2"
  spec.add_development_dependency "fileutils"
  spec.add_development_dependency "parseconfig"

  spec.add_development_dependency "debugger"
end
