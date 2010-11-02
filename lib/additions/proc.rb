class Proc
	include Kaiseki::ParsletCombining
	
	def to_parseable
		Kaiseki::ProcParslet.new self
	end
end