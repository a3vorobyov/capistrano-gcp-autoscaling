lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/gcp/autoscaling/version'

Gem::Specification.new do |spec|
  spec.name          = 'capistrano-gcp-autoscaling'
  spec.version       = Capistrano::Gcp::Autoscaling::VERSION
  spec.authors       = ['Aleksei Vorobyov']
  spec.email         = ['a3.vorobyov@gmail.com']

  spec.summary       = 'Capistrano plugin for deploying to GCP instance groups'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/a3vorobyov/capistrano-gcp-autoscaling'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '>= 2.1.4'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.66'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.32'

  spec.add_dependency 'capistrano', '~> 3.0'
  spec.add_dependency 'google-api-client', '~> 0.8'
  spec.add_dependency 'googleauth', '>= 0.6'
end
