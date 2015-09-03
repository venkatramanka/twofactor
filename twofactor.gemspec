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
  s.description = "This gem could be used for making your webapp's signup/login 2Factor compliant."\
                  " Twofactor lets you customize the way you want the whole 2Step verification to be "\
                  " working. Unlike other 2-factor gems out there, Twofactor does not really require "\
                  "devise. Instead, it creates an endpoint at your command and operates from there.\n"\
                  "    All you have to do is to make your user register for 2Factor using that endpoint."\
                  " And get a 2Factor code from him each time he logs in & call the gem's validator to "\
                  "check if the code is valid." 
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.2"
  s.add_dependency 'rqrcode'
  s.add_dependency 'totp'

  s.add_development_dependency "sqlite3"
end
