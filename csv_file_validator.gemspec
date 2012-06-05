$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "csv_validator"
  s.version     = "0.0.1"
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of CsvValidator."
  s.description = "TODO: Description of CsvValidator."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.require_paths = %w(lib)
  s.add_dependency("activemodel", ">= 0")
  s.add_development_dependency("rake")
  s.add_development_dependency("rspec", ">= 0")
  s.add_development_dependency("rspec-rails")
  s.add_development_dependency("ruby-debug19")
  s.add_development_dependency("guard")
  s.add_development_dependency("guard-rspec")
  
end
