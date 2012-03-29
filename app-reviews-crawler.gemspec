# -*- encoding: utf-8 -*-
require File.expand_path('../lib/app-reviews-crawler/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Mu-ik Jeon"]
  gem.email         = ["muikor@gmail.com"]
  gem.description   = %q{Mobile App Review Crawler}
  gem.summary       = %q{mobile app review crawler}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "app-reviews-crawler"
  gem.require_paths = ["lib"]
  gem.version       = App::Reviews::Crawler::VERSION
end
