# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "yuicssmin/version"

Gem::Specification.new do |s|
  s.name        = "yuicssmin"
  s.version     = Yuicssmin::VERSION
  s.author      = "Matthias Siegel"
  s.email       = "matthias.siegel@gmail.com"
  s.homepage    = "https://github.com/matthiassiegel/yuicssmin"
  s.summary     = "Ruby wrapper for the Javascript port of YUI's CSS compressor"
  s.description = <<-EOF
    
  EOF
  
  s.extra_rdoc_files = [
    "LICENSE.md",
    "README.md"
  ]
  
  s.license = "MIT"
  s.rubyforge_project = "yuicssmin"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  
  s.add_runtime_dependency "execjs", ">= 0.3.0"
  s.add_runtime_dependency "multi_json", ">= 1.0.2"
end
