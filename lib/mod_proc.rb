class Proc
	include Kaiseki::Parseable
	
	def to_parseable
		Kaiseki::Action.new self
	end
end