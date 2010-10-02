require 'kaiseki'

class String
	include Kaiseki::ParsletCombining
	
	def to_parseable
		Kaiseki::StringParslet.new self
	end
end