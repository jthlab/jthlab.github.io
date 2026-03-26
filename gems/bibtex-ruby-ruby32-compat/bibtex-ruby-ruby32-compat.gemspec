Gem::Specification.new do |spec|
  spec.name = "bibtex-ruby-ruby32-compat"
  spec.version = "0.1.0"
  spec.summary = "Ruby 3.2 compatibility patch for bibtex-ruby 4.x"
  spec.authors = ["Local"]
  spec.files = Dir["lib/**/*.rb"]
  spec.require_paths = ["lib"]

  spec.add_dependency "bibtex-ruby", "~> 4.0"
end
