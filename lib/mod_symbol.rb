class Symbol
	include Kaiseki::Parseable
	
	def to_parseable
		if self == :EOF
			Kaiseki::EOFParser.new
		else
			Kaiseki::SymbolParser.new self
		end
	end
	
	def to_instance_variable
		if self[0] == '@'
			:"@#{self.to_s.sub /@+/, ''}"
		else
			:"@#{self}"
		end
	end
end