require 'kaiseki'

class Regexp
	include Kaiseki::ParsletCombining
	
	def to_parseable
		Kaiseki::RegexpParslet.new self
	end
end