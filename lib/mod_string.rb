class String
	include Kaiseki::Parseable
	
	def to_parseable
		Kaiseki::StringParser.new self
	end
	
	def to_stream
		Kaiseki::Stream.new self
	end
end