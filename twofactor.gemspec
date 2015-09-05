$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "twofactor/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "twofactor"
  s.version     = Twofactor::VERSION
  s.authors     = ["venkatramanka"]
  s.email       = ["venkatka@outlook.com"]
  s.homepage    = "https://github.com/venkatramanka/twofactor"
  s.summary     = "A gem to integrate your Rails app with Google 2Factor-authenticator mobile apps"
  s.description = "A gem to integrate your Rails app with Google 2Factor-authenticator mobile apps" 
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.2"
  s.add_dependency 'rqrcode'
  s.add_dependency 'totp'

end
