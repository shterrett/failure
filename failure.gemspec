Gem::Specification.new do |s|
  s.name        = 'failure'
  s.version     = '0.1.0'
  s.date        = '2018-04-18'
  s.summary     = "Either and Option functor/applicative/monad"
  s.description = "Implements Either and Option a la Haskell"
  s.authors     = ["Stuart Terrett"]
  s.email       = 'shterrett@gmail.com'
  s.files       = ["lib/failure.rb"]
  s.homepage    = 'http://github.com/shterrett/failure'
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency("rspec", "~> 3.7")
  s.add_development_dependency("rake", "~> 12.3")
  s.add_development_dependency("simplecov", "~> 0.16")
  s.add_development_dependency("pry", "~> 0.11")
end
