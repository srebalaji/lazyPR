# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lazy_pr/version'

Gem::Specification.new do |spec|
  spec.name          = "lazypr"
  spec.version       = LazyPr::VERSION
  spec.authors       = ["Srebalaji Thirumalai"]
  spec.email         = ["srebalaji@outlook.com"]
  spec.add_dependency 'octokit', '~> 4.0'
  spec.summary       = %q{Create a github PR from the command line}
  spec.description   = %q{This gem helps you to create a PR from the current branch against the branch you specify. }
  spec.homepage      = ""
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = ""
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.executables   = ["lazypr"]
  spec.require_paths = ["lib"]
  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
end
