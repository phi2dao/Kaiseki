class Regexp
	include Kaiseki::Parseable
	
	def to_parseable
		Kaiseki::RegexpParser.new self
	end
end