require_relative "lib/sidediq/version"

Gem::Specification.new do |spec|
  spec.name        = "sidediq"
  spec.version     = Sidediq::VERSION
  spec.authors     = [ "fobiasmog" ]
  spec.email       = [ "zbrejkin@yandex.ru" ]
  spec.homepage    = "https://github.com/fobiasmog/sidediq"
  spec.summary     = "Sidediq: ZeroMQ ActiveJob adapter for Ruby on Rails"
  spec.description = "Like Sidekiq but diq, made just for fun."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  spec.executables = [ "sidediq" ]

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib,bin}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.0.4"
end
