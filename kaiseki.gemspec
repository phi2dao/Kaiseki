require './lib/kaiseki'

Gem::Specification.new do |s|
	s.name = 'kaiseki'
	s.version = Kaiseki::VERSION
	s.platform = Gem::Platform::RUBY
	s.author = 'William Hamilton-Levi'
	s.email = 'whamilt1@swarthmore.edu'
	s.homepage = 'http://github.com/phi2dao/Kaiseki'
	s.summary = 'A parsing expression grammar generator written in ruby.'
	s.description = 'A parsing expression grammar generator written in ruby.'
	
	s.has_rdoc = false
	
	s.require_path = 'lib'
	s.add_development_dependency 'rspec'
	
	s.files = Dir['lib/kaiseki.rb', 'lib/additions/*.rb', 'lib/grammar/*.rb']
	s.test_files = Dir['lib/specs/*.rb']
end