require './lib/'

Gem::Specification.new do |s|
	s.name = ''
	s.version = Kaiseki::VERSION
	s.platform = Gem::Platform::RUBY
	s.author = 'William Hamilton-Levi'
	s.email = 'whamilt1@swarthmroe.edu'
	s.homepage = 'https://github.com/phi2dao/Kaiseki'
	s.summary = 'A parsing expression grammar generator'
	s.description = 'A parsing expression grammar generator coded entirely in ruby.  Currently can not create memoizing grammars.'
	
	s.files = Dir['lib/**/*'] + 'README'
	s.require_path = 'lib'
end