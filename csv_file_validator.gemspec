$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "csv_validator"
  s.version     = "0.0.1"
  s.authors     = ["Matt Fordham"]
  s.email       = ["matt@revolvercreative.com"]
  s.homepage    = "http://github.com/mattfordham/CSV-Validator"
  s.summary     = "A CVS validator for Rails 3."
  s.description = "A CVS validator for Rails 3. See homepage for details: http://github.com/mattfordham/CSV-Validator."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.require_paths = %w(lib)
  s.add_dependency("activemodel", ">= 0")
  s.add_dependency "mail"
  s.add_development_dependency("rake")
  s.add_development_dependency("rspec", ">= 0")
  s.add_development_dependency("rspec-rails")
  s.add_development_dependency("ruby-debug19")
  s.add_development_dependency("guard")
  s.add_development_dependency("guard-rspec")
  
end
